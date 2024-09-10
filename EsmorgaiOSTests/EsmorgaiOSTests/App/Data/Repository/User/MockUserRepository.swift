//
//  MockUserRepository.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockUserRepository: UserRepositoryProtocol {

    var mockUser: UserModels.User?
    var mockError: NetworkError = NetworkError.generalError(code: 500)

    func login(email: String, password: String) async throws -> UserModels.User {
        guard let mockUser else {
            throw mockError
        }
        return mockUser
    }

    func register(name: String, lastName: String, pass: String, email: String) async throws -> UserModels.User {
        guard let mockUser else {
            throw mockError
        }
        return mockUser
    }
}
