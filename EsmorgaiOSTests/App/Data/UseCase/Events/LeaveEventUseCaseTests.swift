//
//  LeaveEventUseCaseTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 16/10/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class LeaveEventUseCaseTests {

    private var sut: LeaveEventUseCase!
    private var mockEventsRepository: MockEventsRepository!

    init() {
        mockEventsRepository = MockEventsRepository()
        sut = LeaveEventUseCase(eventsRepository: mockEventsRepository)
    }

    deinit {
        mockEventsRepository = nil
        sut = nil
    }

    @Test
    func test_given_leave_event_when_success_result_then_return_correct_events() async {
        mockEventsRepository.leaveEventResult = true

        let result = await self.sut.execute(input: "123")
        var successCalled: Bool?
        switch result {
        case .success:
            successCalled = true
        case .failure(let error):
            Issue.record("Unexpected error: \(error)")
        }

        #expect(successCalled ?? false)
    }

    @Test
    func test_given_leave_event_when_failure_result_then_return_correct_error() async {

        let result = await self.sut.execute(input: "1234")
        switch result {
        case .success:
            Issue.record("Unexpected error: Success Result")
        case .failure(let error):
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
