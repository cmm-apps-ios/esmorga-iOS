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

    func fetchEvents() async throws -> [RemoteEventListModel.Event]? {
        guard let mockEvents else {
            throw mockError
        }
        return mockEvents
    }
}
