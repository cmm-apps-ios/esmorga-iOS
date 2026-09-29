//
//  PollDetailsViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class PollDetailsViewModelTests {

    private var sut: PollDetailsViewModel!
    private var mockSendVoteUseCase: MockSendVotePollUseCase!
    private var spyCoordinator: SpyCoordinator!

    private var polledPolls: [Poll] = []
    private var notificationObserver: NSObjectProtocol?

    init() {
        spyCoordinator = SpyCoordinator()
        mockSendVoteUseCase = MockSendVotePollUseCase()
        sut = PollDetailsViewModel(poll: PollBuilder().build(),
                                   coordinator: spyCoordinator,
                                   sendVoteUseCase: mockSendVoteUseCase)
        notificationObserver = NotificationCenter.default.addObserver(forName: .pollUpdated,
                                                                      object: nil,
                                                                      queue: .main) { [weak self] notification in
                                                                      guard let poll = notification.userInfo?["poll"] as? Poll else { return }
                                                                      self?.polledPolls.append(poll)
                                                          }
    }

    deinit {
        if let notificationObserver {
            NotificationCenter.default.removeObserver(notificationObserver)
        }
        mockSendVoteUseCase = nil
        spyCoordinator = nil
        sut = nil
    }

    private func makeSut(poll: Poll) {
        sut = PollDetailsViewModel(poll: poll,
                                   coordinator: spyCoordinator,
                                   sendVoteUseCase: mockSendVoteUseCase)
    }

    private func flushMainQueue() {
        RunLoop.main.run(until: Date().addingTimeInterval(0.05))
    }

    private var singlePoll: Poll {
        PollBuilder().with(id: "1").build()
    }

    private var multiplePoll: Poll {
        PollBuilder().with(id: "2").with(isMultipleChoice: true).build()
    }

    private var votedSinglePoll: Poll {
        PollBuilder().with(id: "1").with(userSelectedOptions: ["opt1"]).build()
    }

    private var expiredSinglePoll: Poll {
        PollBuilder().with(id: "1").with(voteDeadline: Date().addingTimeInterval(-60)).build()
    }

    @MainActor
    @Test
    func test_given_vote_deadline_passed_then_deadline_is_passed_and_button_is_disabled() {
        makeSut(poll: expiredSinglePoll)

        #expect(self.sut.isDeadlinePassed)
        #expect(!self.sut.isButtonEnabled)
        #expect(self.sut.model.voteButton.isDeadlinePassed)
    }

    @MainActor
    @Test
    func test_given_poll_without_vote_then_button_title_is_vote_and_when_user_has_voted_it_is_update_vote() {
        makeSut(poll: singlePoll)

        #expect(self.sut.model.voteButton.title == LocalizationKeys.Buttons.vote.localize())

        makeSut(poll: votedSinglePoll)

        #expect(self.sut.model.voteButton.title == LocalizationKeys.Buttons.updateVote.localize())
    }

    @MainActor
    @Test
    func test_given_vote_deadline_not_passed_then_button_enabled_only_with_selection() {
        makeSut(poll: singlePoll)

        #expect(!self.sut.isDeadlinePassed)
        #expect(!self.sut.isButtonEnabled)

        self.sut.toggleOption("opt1")

        #expect(self.sut.isButtonEnabled)
    }

    @MainActor
    @Test
    func test_given_option_toggled_when_single_choice_then_only_one_option_is_selected() {
        makeSut(poll: singlePoll)

        self.sut.toggleOption("opt1")
        #expect(self.sut.currentSelection == ["opt1"])

        self.sut.toggleOption("opt2")
        #expect(self.sut.currentSelection == ["opt2"])

        self.sut.toggleOption("opt2")
        #expect(self.sut.currentSelection.isEmpty)
    }

    @MainActor
    @Test
    func test_given_option_toggled_when_multiple_choice_then_multiple_options_can_be_selected() {
        makeSut(poll: multiplePoll)

        self.sut.toggleOption("opt1")
        self.sut.toggleOption("opt2")
        self.sut.toggleOption("opt1")

        #expect(self.sut.currentSelection == ["opt2"])
    }

    @MainActor
    @Test
    func test_given_option_toggled_when_deadline_passed_then_selection_is_not_changed() {
        makeSut(poll: expiredSinglePoll)

        self.sut.toggleOption("opt1")

        #expect(self.sut.currentSelection.isEmpty)
    }

    @MainActor
    @Test
    func test_given_vote_when_button_not_enabled_then_voting_is_not_initiated() async {
        makeSut(poll: singlePoll)

        await self.sut.vote()

        #expect(self.sut.voteState == .idle)
        #expect(!self.sut.isLoading)
    }

    @MainActor
    @Test
    func test_given_vote_when_success_then_state_is_success_and_poll_updated_notification_posted() async {
        let votedPoll = votedSinglePoll
        mockSendVoteUseCase.mockVotedPoll = votedPoll
        makeSut(poll: singlePoll)

        self.sut.toggleOption("opt1")
        self.polledPolls = []

        await self.sut.vote()
        self.flushMainQueue()

        #expect(self.sut.voteState == .success)
        #expect(self.sut.poll == votedPoll)
        #expect(self.sut.currentSelection == ["opt1"])
        #expect(self.sut.hasVoted)
        #expect(self.sut.model.voteButton.title == LocalizationKeys.Buttons.updateVote.localize())
        #expect(self.sut.model.voteButton.isLoading == false)
        #expect(self.polledPolls == [votedPoll])
        #expect(self.sut.snackBar.isShown)
        #expect(self.sut.snackBar.message == LocalizationKeys.Snackbar.voteSubmitted.localize())
    }

    @MainActor
    @Test
    func test_given_vote_when_failure_then_state_is_failure() async {
        mockSendVoteUseCase.mockVotedPoll = nil
        makeSut(poll: singlePoll)

        self.sut.toggleOption("opt1")
        await self.sut.vote()

        #expect(self.sut.voteState != .idle)
        #expect(self.sut.voteState != .success)
        #expect(self.sut.voteState != .loading)
        #expect(!self.sut.isLoading)
        #expect(self.sut.model.voteButton.isLoading == false)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .commonError)))
    }

    @MainActor
    @Test
    func test_given_message_cleared_then_state_returns_to_idle() {
        makeSut(poll: singlePoll)

        self.sut.clearMessage()

        #expect(self.sut.voteState == .idle)
    }
}
