//
//  ExploreHomeViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class ExploreHomeViewModelTests {

    private var sut: ExploreHomeViewModel!
    private var mockGetEventListUseCase: MockGetEventListUseCase!
    private var mockGetPollsUseCase: MockGetPollsUseCase!
    private var eventListViewModel: EventListViewModel!
    private var pollListViewModel: PollListViewModel!
    private var spyCoordinator: SpyCoordinator!

    init(withPolls: Bool = true) {
        spyCoordinator = SpyCoordinator()
        mockGetEventListUseCase = MockGetEventListUseCase()
        mockGetPollsUseCase = MockGetPollsUseCase()
        eventListViewModel = EventListViewModel(coordinator: spyCoordinator,
                                                getEventListUseCase: mockGetEventListUseCase)
        pollListViewModel = withPolls ? PollListViewModel(coordinator: spyCoordinator,
                                                          getPollListUseCase: mockGetPollsUseCase) : nil
        sut = ExploreHomeViewModel(coordinator: spyCoordinator,
                                   eventListViewModel: eventListViewModel,
                                   pollListViewModel: pollListViewModel)
    }

    deinit {
        try? AccountSession.buildCodableKeychain().delete()
        mockGetEventListUseCase = nil
        mockGetPollsUseCase = nil
        eventListViewModel = nil
        pollListViewModel = nil
        spyCoordinator = nil
        sut = nil
    }

    @MainActor
    private func flushMainQueue() async {
        await Task.yield()
        await Task.yield()
    }

    @MainActor
    @Test
    func test_given_load_when_events_and_polls_success_then_state_is_loaded() async {
        mockGetEventListUseCase.mockResponse = ([EventBuilder().build()], false)
        mockGetPollsUseCase.mockPolls = [PollBuilder().build()]

        await TestHelper.fullfillTask {
            await self.sut.load(forceRefresh: false)
        }
        await self.flushMainQueue()

        #expect(self.sut.events == [EventBuilder().build()])
        #expect(self.sut.polls == [PollBuilder().build()])
        #expect(self.sut.state == .loaded)
        #expect(self.sut.isUserLogged)
    }

    @MainActor
    @Test
    func test_given_load_when_events_fail_then_state_is_error() async {
        mockGetEventListUseCase.mockResponse = nil
        mockGetPollsUseCase.mockPolls = [PollBuilder().build()]

        await TestHelper.fullfillTask {
            await self.sut.load(forceRefresh: false)
        }
        await self.flushMainQueue()

        #expect(self.sut.state == .error)
        #expect(self.sut.events.isEmpty)
    }

    @MainActor
    @Test
    func test_given_load_when_polls_fail_then_state_is_error() async {
        mockGetEventListUseCase.mockResponse = ([EventBuilder().build()], false)
        mockGetPollsUseCase.mockPolls = nil

        await TestHelper.fullfillTask {
            await self.sut.load(forceRefresh: false)
        }
        await self.flushMainQueue()

        #expect(self.sut.state == .error)
        #expect(self.sut.events == [EventBuilder().build()])
        #expect(self.sut.polls.isEmpty)
    }


    @Test
    func test_given_event_tapped_then_navigate_to_details_is_called() {
        let event = EventBuilder().with(eventId: "1").build()

        sut.eventTapped(event)

        #expect(self.spyCoordinator.pushCalled)
        #expect(self.spyCoordinator.destination == .eventDetails(event))
    }

    @Test
    func test_given_poll_tapped_when_logged_then_navigate_to_details_is_called() {
        let poll = PollBuilder().with(id: "1").build()

        sut.pollTapped(poll)

        #expect(self.spyCoordinator.pushCalled)
        #expect(self.spyCoordinator.destination == .pollDetails(poll))
    }

    @Test
    func test_given_poll_tapped_when_not_logged_then_no_navigation_is_called() {
        sut = ExploreHomeViewModel(coordinator: spyCoordinator,
                                   eventListViewModel: eventListViewModel,
                                   pollListViewModel: nil)
        let poll = PollBuilder().with(id: "1").build()

        sut.pollTapped(poll)

        #expect(!self.spyCoordinator.pushCalled)
    }

    @MainActor
    @Test
    func test_given_retry_then_force_refresh_is_applied_to_both_lists() async {
        mockGetEventListUseCase.mockResponse = ([EventBuilder().build()], false)
        mockGetPollsUseCase.mockPolls = [PollBuilder().build()]

        await TestHelper.fullfillTask {
            await self.sut.retry()
        }
        await self.flushMainQueue()

        #expect(self.sut.state == .loaded)
        #expect(self.sut.events == [EventBuilder().build()])
        #expect(self.sut.polls == [PollBuilder().build()])
    }
}
