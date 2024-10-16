//
//  MockRemoteMyEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 24/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockRemoteMyEventsDataSource: RemoteMyEventsDataSourceProtocol {

    var mockEvents: [RemoteEventListModel.Event]?
    var mockError: NetworkError = NetworkError.generalError(code: 500)
    var mockJoinedEvent: Bool = false
    var eventIdJoined: String?

    func fetchEvents() async throws -> [RemoteEventListModel.Event] {
        guard let mockEvents else {
            throw mockError
        }
        return mockEvents
    }

    func joinEvent(id: String) async throws {
        eventIdJoined = id
        guard mockJoinedEvent else {
            throw mockError
        }
    }
}
