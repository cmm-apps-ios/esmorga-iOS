//
//  MockEventsRepository.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockEventsRepository: EventsRepositoryProtocol {

    var mockResult: ([EventModels.Event], Bool)?
    var refreshValue: Bool?

    var joinEventResult: Bool = false
    var leaveEventResult: Bool = false
    var eventIdToJoin: String?

    func getEventList(refresh: Bool) async throws -> ([EventModels.Event], Bool) {
        refreshValue = refresh
        guard let mockResult else {
            throw NetworkError.generalError(code: 500)
        }
        return mockResult
    }

    func joinEvent(id: String) async throws {
        eventIdToJoin = id
        guard joinEventResult else {
            throw NetworkError.generalError(code: 500)
        }
    }

    func leaveEvent(id: String) async throws {
        eventIdToJoin = id
        guard leaveEventResult else {
            throw NetworkError.generalError(code: 500)
        }
    }
}
