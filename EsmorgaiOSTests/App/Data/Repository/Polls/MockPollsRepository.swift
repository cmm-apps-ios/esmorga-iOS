//
//  MockPollsRepository.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class MockPollsRepository: PollsRepositoryProtocol {

    var mockPolls: [Poll]?
    var mockVotedPoll: Poll?
    var mockError: Error?
    var voteRequest: VotePollRequest?

    init() {
        mockPolls = [PollBuilder().build()]
    }

    func fetchPolls() async throws -> [Poll] {
        if let mockError {
            throw mockError
        }
        return mockPolls ?? []
    }

    func sendVote(vote: VotePollRequest) async throws -> Poll {
        voteRequest = vote
        guard let mockVotedPoll else {
            throw mockError ?? NetworkError.generalError(code: 500)
        }
        return mockVotedPoll
    }
}
