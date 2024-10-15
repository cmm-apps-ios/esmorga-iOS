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
    var clearAllCalled: Bool = false

    func getEvents() async -> [EventModels.Event] {
        return mockEvents
    }

    func saveEvents(_ events: [EventModels.Event]) async throws {
        savedEvents = events
        return
    }

    func clearAll() {
        savedEvents = nil
        clearAllCalled = true
    }
}
