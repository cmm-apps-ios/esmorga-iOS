//
//  PollsRepositoryTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class PollsRepositoryTests {

    private var sut: PollsRepository!
    private var mockRemoteDataSource: MockRemotePollsDataSource!

    init() {
        mockRemoteDataSource = MockRemotePollsDataSource()
        sut = PollsRepository(remoteDataSource: mockRemoteDataSource)
    }

    deinit {
        mockRemoteDataSource = nil
        sut = nil
    }

    @Test
    func test_given_fetch_polls_when_success_result_then_return_correct_polls() async {
        let remotePolls = [RemotePollBuilder().build(),
                           RemotePollBuilder().with(pollId: "5678").build()]
        mockRemoteDataSource.mockRemotePolls = remotePolls

        let polls = try? await sut.fetchPolls()

        #expect(polls?.count == 2)
        #expect(polls?.first?.id == "1234")
        #expect(polls?.last?.id == "5678")
        #expect(polls == remotePolls.map { $0.toDomain() })
    }

    @Test
    func test_given_send_vote_when_success_result_then_return_correct_poll() async {
        let votedRemotePoll = RemotePollBuilder().with(userSelectedOptions: ["opt1"]).build()
        mockRemoteDataSource.mockVotedRemotePoll = votedRemotePoll

        let result = try? await sut.sendVote(vote: VotePollRequest(pollId: "1234",
                                                                   selectedOptionIds: ["opt1"]))

        #expect(result == votedRemotePoll.toDomain())
        #expect(mockRemoteDataSource.voteRequest?.pollId == "1234")
        #expect(mockRemoteDataSource.voteRequest?.selectedOptionIds == ["opt1"])
    }

    @Test
    func test_given_send_vote_when_fail_then_return_correct_error() async {

        do {
            _ = try await sut.sendVote(vote: VotePollRequest(pollId: "1234",
                                                             selectedOptionIds: ["opt1"]))
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
