//
//  PollDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 23/09/2026.
//

import Foundation

@MainActor
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

    private let voteHandler: (
        _ pollID: String,
        _ selectedOptionIDs: [String]
    ) async throws -> Void

    init(
        poll: Poll,
        voteHandler: @escaping (
            _ pollID: String,
            _ selectedOptionIDs: [String]
        ) async throws -> Void
    ) {
        self.poll = poll
        self.currentSelection = Set(poll.userSelectedOptions)
        self.voteHandler = voteHandler
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

    func vote() async {
        guard isButtonEnabled else {
            return
        }

        voteState = .loading

        do {
            try await voteHandler(
                poll.id,
                Array(currentSelection)
            )

            poll = Poll(
                id: poll.id,
                name: poll.name,
                description: poll.description,
                options: poll.options,
                voteDeadline: poll.voteDeadline,
                isMultipleChoice: poll.isMultipleChoice,
                userSelectedOptions: Array(currentSelection)
            )

            voteState = .success
        } catch {
            voteState = .failure(
                error.localizedDescription
            )
        }
    }

    func clearMessage() {
        voteState = .idle
    }
}
