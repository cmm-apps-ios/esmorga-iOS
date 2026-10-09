//
//  MockGetEventAttendeesUseCase.swift
//  EsmorgaiOSTests
//

import Foundation
@testable import EsmorgaiOS

final class MockGetEventAttendeesUseCase: GetEventAttendeesUseCaseAlias {

    var mockAttendees: [EventAttendee] = []

    override func job(input: String) async -> GetEventAttendeesUseCaseResult {
        return .success(mockAttendees)
    }
}
