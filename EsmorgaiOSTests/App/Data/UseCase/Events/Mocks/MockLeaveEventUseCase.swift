//
//  MockLeaveEventUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 16/10/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockLeaveEventUseCase: LeaveEventUseCaseAlias {

    var mockResult: Bool = false

    override func job(input: String) async -> LeaveEventUseCaseResult {
        guard mockResult else {
            return .failure(NetworkError.generalError(code: 500))
        }
        return .success(())
    }
}
