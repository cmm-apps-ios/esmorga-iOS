//
//  PollListViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class PollListViewModelTests {

    private var sut: PollListViewModel!
    private var mockGetPollsUseCase: MockGetPollsUseCase!
    private var spyCoordinator: SpyCoordinator!

    init() {
        mockGetPollsUseCase = MockGetPollsUseCase()
        spyCoordinator = SpyCoordinator()
        sut = PollListViewModel(coordinator: spyCoordinator,
                                getPollListUseCase: mockGetPollsUseCase)
    }

    deinit {
        mockGetPollsUseCase = nil
        spyCoordinator = nil
        sut = nil
    }

    private func runMainLoop() {
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
    }

    private func postPollUpdated(userInfo: [AnyHashable: Any]?) {
        NotificationCenter.default.post(name: .pollUpdated,
                                        object: nil,
                                        userInfo: userInfo)
        runMainLoop()
    }

    @MainActor
    @Test
    func test_given_get_poll_list_when_success_then_polls_are_correct() async {
        let polls = [PollBuilder().with(id: "1").build(),
                     PollBuilder().with(id: "2").build()]
        mockGetPollsUseCase.mockPolls = polls

        await TestHelper.fullfillTask {
            await self.sut.getPollList(forceRefresh: false)
        }

        #expect(self.sut.polls == polls)
        #expect(self.sut.state == .loaded)
    }

    @MainActor
    @Test
    func test_given_get_poll_list_when_success_and_empty_then_state_is_empty() async {
        mockGetPollsUseCase.mockPolls = []

        await TestHelper.fullfillTask {
            await self.sut.getPollList(forceRefresh: false)
        }

        #expect(self.sut.polls.isEmpty)
        #expect(self.sut.state == .empty)
    }

    @MainActor
    @Test
    func test_given_get_poll_list_when_failure_then_state_is_error() async {
        mockGetPollsUseCase.mockPolls = nil

        await TestHelper.fullfillTask {
            await self.sut.getPollList(forceRefresh: false)
        }

        #expect(self.sut.polls.isEmpty)
        #expect(self.sut.state == .error)
    }

    @MainActor
    @Test
    func test_given_get_poll_list_when_force_refresh_then_polls_are_updated() async {
        let polls = [PollBuilder().with(id: "1").build()]
        mockGetPollsUseCase.mockPolls = polls

        await TestHelper.fullfillTask {
            await self.sut.getPollList(forceRefresh: true)
        }

        #expect(self.sut.polls == polls)
        #expect(self.sut.state == .loaded)
    }

    @Test
    func test_given_poll_tapped_then_navigate_to_details_is_called() {

        let poll = PollBuilder().with(id: "1").build()

        sut.pollTapped(poll)

        #expect(self.spyCoordinator.pushCalled)
        #expect(self.spyCoordinator.destination == .pollDetails(poll))
    }

    @MainActor
    @Test
    func test_given_poll_updated_notification_when_same_poll_then_polls_are_updated() {
        let originalPoll = PollBuilder().with(id: "1").build()
        let updatedPoll = PollBuilder().with(id: "1").with(name: "New name").build()

        sut.polls = [originalPoll]

        postPollUpdated(userInfo: ["poll": updatedPoll])

        #expect(self.sut.polls == [updatedPoll])
    }

    @MainActor
    @Test
    func test_given_poll_updated_notification_when_unknown_poll_then_polls_are_not_changed() {
        let originalPoll = PollBuilder().with(id: "1").build()
        let otherPoll = PollBuilder().with(id: "other").build()

        sut.polls = [originalPoll]

        postPollUpdated(userInfo: ["poll": otherPoll])

        #expect(self.sut.polls == [originalPoll])
    }

    @MainActor
    @Test
    func test_given_poll_updated_notification_without_payload_then_polls_are_not_changed() {
        let originalPoll = PollBuilder().with(id: "1").build()

        sut.polls = [originalPoll]

        postPollUpdated(userInfo: nil)

        #expect(self.sut.polls == [originalPoll])
    }

    @MainActor
    @Test
    func test_given_poll_updated_notification_with_invalid_payload_then_polls_are_not_changed() {
        let originalPoll = PollBuilder().with(id: "1").build()

        sut.polls = [originalPoll]

        postPollUpdated(userInfo: ["poll": "not a poll"])

        #expect(self.sut.polls == [originalPoll])
    }
}
