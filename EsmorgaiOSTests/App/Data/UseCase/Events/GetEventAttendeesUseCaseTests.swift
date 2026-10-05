//
//  GetEventAttendeesUseCaseTests.swift
//  EsmorgaiOSTests
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class GetEventAttendeesUseCaseTests {

    private var sut: GetEventAttendeesUseCase!
    private var mockEventsRepository: MockEventsRepository!

    init() {
        mockEventsRepository = MockEventsRepository()
        sut = GetEventAttendeesUseCase(eventsRepository: mockEventsRepository)
    }

    deinit {
        mockEventsRepository = nil
        sut = nil
    }

    @Test
    func test_given_get_event_attendees_when_success_then_return_attendees() async {
        mockEventsRepository.mockEventAttendees = [EventAttendee(name: "Alice", hasPayed: false)]

        let result = await sut.execute(input: "1234")
        switch result {
        case .success(let attendees):
            #expect(attendees.count == 1)
            #expect(attendees.first?.name == "Alice")
        case .failure:
            Issue.record("Unexpected failure")
        }
    }

    @Test
    func test_given_get_event_attendees_when_failure_then_return_error() async {
        mockEventsRepository.mockEventAttendees = nil

        let result = await sut.execute(input: "1234")
        switch result {
        case .success:
            Issue.record("Unexpected success")
        case .failure(let error):
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
