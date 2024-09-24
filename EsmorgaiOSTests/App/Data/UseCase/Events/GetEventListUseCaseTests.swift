//
//  GetEventListUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 30/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class GetEventListUseCaseTests: XCTestCase {

    private var sut: GetEventListUseCase!
    private var mockEventsRepository: MockEventsRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockEventsRepository = MockEventsRepository()
        sut = GetEventListUseCase(eventsRepsitory: mockEventsRepository)
    }

    override func tearDownWithError() throws {
        mockEventsRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_event_list_when_success_result_then_return_correct_events() async {
        let mockResult = ([EventBuilder().build()], false)
        mockEventsRepository.mockResult = mockResult

        let result = await self.sut.execute(input: true)
        switch result {
        case .success(let data):
            expect(data).to(equal(mockResult))
            expect(self.mockEventsRepository.refreshValue).to(beTrue())
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_get_event_list_when_failure_result_then_return_correct_error() async {

        let result = await self.sut.execute(input: true)
        switch result {
        case .success:
            XCTFail("Unexpected error: Success Result")
        case .failure(let error):
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }
}
