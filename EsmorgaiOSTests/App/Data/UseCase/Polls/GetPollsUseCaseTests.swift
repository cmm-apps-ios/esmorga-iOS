//
//  GetPollsUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class GetPollsUseCaseTests {

    private var sut: GetPollsUseCase!
    private var mockPollsRepository: MockPollsRepository!

    init() {
        mockPollsRepository = MockPollsRepository()
        sut = GetPollsUseCase(pollsRepository: mockPollsRepository)
    }

    deinit {
        mockPollsRepository = nil
        sut = nil
    }

    @Test
    func test_given_get_polls_when_success_result_then_return_correct_polls() async {
        let polls = [PollBuilder().with(id: "1234").build(),
                     PollBuilder().with(id: "5678").build()]
        mockPollsRepository.mockPolls = polls

        let result = await self.sut.execute()

        switch result {
        case .success(let data):
            #expect(data == polls)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func test_given_get_polls_when_failure_result_then_return_correct_error() async {
        mockPollsRepository.mockPolls = nil
        mockPollsRepository.mockError = NetworkError.generalError(code: 500)

        let result = await self.sut.execute()

        switch result {
        case .success:
            Issue.record("Unexpected success Result")
        case .failure(let error):
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
