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

    func getEventList(refresh: Bool) async throws -> ([EventModels.Event], Bool) {
        refreshValue = refresh
        guard let mockResult else {
            throw NetworkError.generalError(code: 500)
        }
        return mockResult
    }
}
