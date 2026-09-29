//
//  MockRemotePollsDataSource.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class MockRemotePollsDataSource: RemotePollsDataSourceProtocol {

    var mockRemotePolls: [RemotePoll]?
    var mockVotedRemotePoll: RemotePoll?
    var mockError: Error?
    var voteRequest: VotePollRequest?

    init() {
        mockRemotePolls = [RemotePollBuilder().build()]
    }

    func fetchPolls() async throws -> [RemotePoll] {
        if let mockError {
            throw mockError
        }
        return mockRemotePolls ?? []
    }

    func sendVote(vote: VotePollRequest) async throws -> RemotePoll {
        voteRequest = vote
        guard let mockVotedRemotePoll else {
            throw mockError ?? NetworkError.generalError(code: 500)
        }
        return mockVotedRemotePoll
    }
}
