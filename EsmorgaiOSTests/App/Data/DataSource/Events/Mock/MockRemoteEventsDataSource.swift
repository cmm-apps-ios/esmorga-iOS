//
//  MockRemoteEventsDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockRemoteEventsDataSource: RemoteEventsDataSourceProtocol {

    var mockEvents: [RemoteEventListModel.Event]?
    var mockError: NetworkError = NetworkError.generalError(code: 500)
    var mockAttendees: RemoteEventAttendee?

    var createEventShouldThrow: Bool = false
    var createdEventParams: CreateEventParams?

    func fetchEvents() async throws -> [RemoteEventListModel.Event] {
        guard let mockEvents else {
            throw mockError
        }
        return mockEvents
    }

    func createEvent(params: CreateEventParams) async throws {
        createdEventParams = params
        if createEventShouldThrow {
            throw mockError
        }
    }

    func fetchEventAttendees(eventId: String) async throws -> RemoteEventAttendee {
        guard let mockAttendees else {
            throw mockError
        }
        return mockAttendees
    }
}
