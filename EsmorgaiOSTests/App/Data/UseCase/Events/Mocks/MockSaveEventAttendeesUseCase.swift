//
//  MockSaveEventAttendeesUseCase.swift
//  EsmorgaiOSTests
//

import Foundation
@testable import EsmorgaiOS

final class MockSaveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias {

    var savedEventId: String?
    var savedAttendees: [EventAttendee]?

    override func job(input: SaveEventAttendeesUseCaseInput) async -> SaveEventAttendeesUseCaseResult {
        savedEventId = input.eventId
        savedAttendees = input.attendees
        return .success(())
    }
}
