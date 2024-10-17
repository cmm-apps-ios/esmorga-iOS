//
//  GetEventListUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 30/7/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class GetEventListUseCaseTests {

    private var sut: GetEventListUseCase!
    private var mockEventsRepository: MockEventsRepository!

    init() {
        mockEventsRepository = MockEventsRepository()
        sut = GetEventListUseCase(eventsRepository: mockEventsRepository)
    }

    deinit {
        mockEventsRepository = nil
        sut = nil
    }

    @Test
    func test_given_get_event_list_when_success_result_then_return_correct_events() async {
        let mockResult = ([EventBuilder().build()], false)
        mockEventsRepository.mockResult = mockResult

        let result = await self.sut.execute(input: true)
        switch result {
        case .success(let data):
            #expect(data == mockResult)
            #expect(self.mockEventsRepository.refreshValue ?? false)
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test
    func test_given_get_event_list_when_failure_result_then_return_correct_error() async {

        let result = await self.sut.execute(input: true)
        switch result {
        case .success:
            Issue.record("Unexpected error: Success Result")
        case .failure(let error):
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
