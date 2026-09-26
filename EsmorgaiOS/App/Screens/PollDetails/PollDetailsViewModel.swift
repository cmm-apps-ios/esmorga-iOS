//
//  PollDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 23/09/2026.
//

import Foundation

final class PollDetailsViewModel: ObservableObject {

    enum VoteState: Equatable {
        case idle
        case loading
        case success
        case failure(String)
    }

    @Published private(set) var poll: Poll
    @Published private(set) var currentSelection: Set<String>
    @Published private(set) var voteState: VoteState = .idle

    private let sendVoteUseCase: SendVotePollUseCaseAlias

    init(
        poll: Poll,
        sendVoteUseCase: SendVotePollUseCaseAlias = SendVotePollUseCase()
    ) {
        self.poll = poll
        self.currentSelection = Set(poll.userSelectedOptions)
        self.sendVoteUseCase = sendVoteUseCase
    }

    var isDeadlinePassed: Bool {
        Date() > poll.voteDeadline
    }

    var hasVoted: Bool {
        !poll.userSelectedOptions.isEmpty
    }

    var isLoading: Bool {
        voteState == .loading
    }

    var isButtonEnabled: Bool {
        !currentSelection.isEmpty &&
        !isDeadlinePassed &&
        !isLoading
    }

    var buttonText: String {
        hasVoted ? "Update vote" : "Vote"
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
    }

    @MainActor
    func vote() async {
        guard isButtonEnabled else {
            return
        }

        voteState = .loading

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
            voteState = .success

        case .failure(let error):
            voteState = .failure(
                error.localizedDescription
            )
        }
    }

    func clearMessage() {
        voteState = .idle
    }
}
