//
//  SendVotePollUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class SendVotePollUseCaseTests {

    private var sut: SendVotePollUseCase!
    private var mockPollsRepository: MockPollsRepository!
    private let voteRequest = VotePollRequest(pollId: "1234",
                                              selectedOptionIds: ["opt1", "opt2"])

    init() {
        mockPollsRepository = MockPollsRepository()
        sut = SendVotePollUseCase(pollsRepository: mockPollsRepository)
    }

    deinit {
        mockPollsRepository = nil
        sut = nil
    }

    @Test
    func test_given_send_vote_when_success_result_then_return_correct_poll() async {
        let votedPoll = PollBuilder().with(id: "1234").with(userSelectedOptions: ["opt1", "opt2"]).build()
        mockPollsRepository.mockVotedPoll = votedPoll

        let result = await self.sut.execute(input: voteRequest)

        switch result {
        case .success(let poll):
            #expect(poll == votedPoll)
            #expect(self.mockPollsRepository.voteRequest?.pollId == voteRequest.pollId)
            #expect(self.mockPollsRepository.voteRequest?.selectedOptionIds == voteRequest.selectedOptionIds)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func test_given_send_vote_when_failure_result_then_return_correct_error() async {
        mockPollsRepository.mockVotedPoll = nil

        let result = await self.sut.execute(input: voteRequest)

        switch result {
        case .success:
            Issue.record("Unexpected success Result")
        case .failure(let error):
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
