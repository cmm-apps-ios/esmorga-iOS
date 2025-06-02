//
//  MockActivateUserUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 26/5/25.
//

import Foundation
@testable import EsmorgaiOS

final class MockActivateUserUseCase: ActivateUserUseCaseAlias {

    var mockUser: UserModels.User?
    var mockError: ActivateUserError = .generalError

    override func job(input: ActivateUserUseCaseInput) async -> ActivateResult {
        guard let mockUser else {
            return .failure(mockError)
        }
        return .success(mockUser)
    }
}
