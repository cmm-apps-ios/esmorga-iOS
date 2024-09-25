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

    func fetchEvents() async throws -> [RemoteEventListModel.Event] {
        guard let mockEvents else {
            throw mockError
        }
        return mockEvents
    }
}
