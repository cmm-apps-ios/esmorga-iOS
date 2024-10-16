//
//  MockJoinEventUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 15/10/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockJoinEventUseCase: JoinEventUseCaseAlias {

    var mockResult: Bool = false

    override func job(input: String) async -> JoinEventUseCaseResult {
        guard mockResult else {
            return .failure(NetworkError.generalError(code: 500))
        }
        return .success(())
    }
}
