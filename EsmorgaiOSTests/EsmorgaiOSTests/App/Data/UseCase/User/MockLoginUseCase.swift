//
//  MockLoginUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockLoginUseCase: LoginUseCaseAlias {

    var mockUser: UserModels.User?
    var mockError: NetworkError = NetworkError.generalError(code: 500)

    override func job(input: LoginUseCaseInput) async -> LoginResult {
        guard let mockUser else {
            return .failure(mockError)
        }
        return .success(mockUser)
    }
}
