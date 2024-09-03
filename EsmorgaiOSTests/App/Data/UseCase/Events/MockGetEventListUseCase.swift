//
//  MockGetEventListUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockGetEventListUseCase: GetEventListUseCaseAlias {

    var mockResponse: (data: [EventModels.Event], error: Bool)?

    override func job(input: Bool) async -> GetEventListResult {
        guard let mockResponse else {
            return .failure(NetworkError.generalError(code: 500))
        }
        return .success(mockResponse)
    }
}
