//
//  MockCreateEventUseCase.swift
//  EsmorgaiOSTests
//
//  Created by GitHub Copilot on 25/9/26.
//

import Foundation
@testable import EsmorgaiOS

final class MockCreateEventUseCase: CreateEventUseCaseAlias {

    var mockResult: CreateEventUseCaseResult = .success(())
    var executeCalled: Bool = false
    var receivedParams: CreateEventParams?

    override func job(input: CreateEventParams) async -> CreateEventUseCaseResult {
        executeCalled = true
        receivedParams = input
        return mockResult
    }
}
