//
//  MockLocalEventsDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockLocalEventsDataSource: LocalEventsDataSourceProtocol {

    var mockEvents: [EventModels.Event] = []
    var savedEvents: [EventModels.Event]?
    var mockError: NSError = NSError(domain: "LocalEventsDataSource", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update event"])
    var updateEventIdCalled: String?
    var updateEventResult: Bool = false
    var eventIsUserJoined: Bool?
    var clearAllCalled: Bool = false

    func getEvents() async -> [EventModels.Event] {
        return mockEvents
    }

    func saveEvents(_ events: [EventModels.Event]) async throws {
        savedEvents = events
        return
    }

    func updateIsUserJoinedEvent(id: String, isUserJoined: Bool) async throws {
        updateEventIdCalled = id
        eventIsUserJoined = isUserJoined

        guard updateEventResult else {
            throw mockError
        }
    }

    func clearAll() {
        savedEvents = nil
        clearAllCalled = true
    }
}
