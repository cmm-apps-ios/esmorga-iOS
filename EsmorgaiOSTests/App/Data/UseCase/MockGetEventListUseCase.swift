//
//  MockGetEventListUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockGetEventListUseCase: GetEventListUseCaseProtocol {

    var mockResponse: (data: [EventModels.Event], error: Bool)?

    func getEventList(forceRefresh: Bool) async -> GetEventListResult {
        guard let mockResponse else {
            return .failure(NetworkError.genaralError(code: 500))
        }
        return .success(mockResponse)
    }
}
