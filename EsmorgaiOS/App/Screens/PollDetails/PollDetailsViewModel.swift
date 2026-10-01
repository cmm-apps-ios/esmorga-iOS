//
//  PollDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 23/09/2026.
//

import Foundation

enum VoteState: ViewStateProtocol {
    case ready
    case loading
    case success
    case failure
}

enum PollDetails {

    struct Model {
        var voteButton: Button

        struct Button {
            var title: String
            var isLoading: Bool
            var isDeadlinePassed: Bool
        }
    }
}

final class PollDetailsViewModel: BaseViewModel<VoteState> {

    @Published private(set) var poll: Poll
    @Published private(set) var currentSelection: Set<String>
    @Published var model: PollDetails.Model

    private let sendVoteUseCase: SendVotePollUseCaseAlias

    init(
        poll: Poll,
        coordinator: (any CoordinatorProtocol)?,
        sendVoteUseCase: SendVotePollUseCaseAlias = SendVotePollUseCase()
    ) {
        self.poll = poll
        self.currentSelection = Set(poll.userSelectedOptions)
        self.sendVoteUseCase = sendVoteUseCase
        let alreadyVoted = !poll.userSelectedOptions.isEmpty
        self.model = PollDetails.Model(
            voteButton: .init(
                title: alreadyVoted
                    ? LocalizationKeys.Buttons.updateVote.localize()
                    : LocalizationKeys.Buttons.vote.localize(),
                isLoading: false,
                isDeadlinePassed: Date() > poll.voteDeadline
            )
        )
        super.init(coordinator: coordinator)
    }

    var isDeadlinePassed: Bool {
        Date() > poll.voteDeadline
    }

    var hasVoted: Bool {
        !poll.userSelectedOptions.isEmpty
    }

    var isLoading: Bool {
        state == .loading
    }

    var isButtonEnabled: Bool {
        !currentSelection.isEmpty &&
        !isDeadlinePassed &&
        !isLoading
    }

    func toggleOption(_ optionID: String) {
        guard !isDeadlinePassed, !isLoading else {
            return
        }

        if poll.isMultipleChoice {
            if currentSelection.contains(optionID) {
                currentSelection.remove(optionID)
            } else {
                currentSelection.insert(optionID)
            }
        } else {
            if currentSelection.contains(optionID) {
                currentSelection.removeAll()
            } else {
                currentSelection = [optionID]
            }
        }
        updateVoteButton()
    }

    @MainActor
    func vote() async {
        guard isButtonEnabled else {
            return
        }

        state = .loading
        model.voteButton.isLoading = true

        let result = await sendVoteUseCase.execute(
            input: VotePollRequest(
                pollId: poll.id,
                selectedOptionIds: Array(currentSelection)
            )
        )

        switch result {
        case .success(let poll):
            self.poll = poll
            currentSelection = Set(poll.userSelectedOptions)
            state = .success
            updateVoteButton()
            NotificationCenter.default.post(
                name: .pollUpdated,
                object: nil,
                userInfo: ["poll": poll]
            )
            self.snackBar = .init(message: LocalizationKeys.Snackbar.voteSubmitted.localize(),
                                  isShown: true)
        case .failure:
            state = .failure
            model.voteButton.isLoading = false
            self.reportErrorToCrashlytics()
            self.showErrorDialog(type: .commonError)
        }
    }

    private func updateVoteButton() {
        model.voteButton.title = hasVoted
            ? LocalizationKeys.Buttons.updateVote.localize()
            : LocalizationKeys.Buttons.vote.localize()
        model.voteButton.isDeadlinePassed = isDeadlinePassed
        model.voteButton.isLoading = isLoading
    }

    private func showErrorDialog(type: ErrorDialog.DialogType) {
        let dialogModel = ErrorDialogModelBuilder.build(type: type)
        coordinator?.push(destination: .dialog(dialogModel))
    }
}
