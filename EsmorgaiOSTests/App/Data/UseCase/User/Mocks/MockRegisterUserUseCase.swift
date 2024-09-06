//
//  MockRegisterUserUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockRegisterUserUseCase: RegisterUserUseCaseAlias {

    var mockUser: UserModels.User?
    var mockError: RegisterUserError = .generalError

    override func job(input: RegisterUserUseCaseInput) async -> RegisterUserResult {
        guard let mockUser else {
            return .failure(mockError)
        }
        return .success(mockUser)
    }
}
