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

    func logoutUser() async -> Bool {
        mockUser = nil
        return true
    }


    func register(name: String, lastName: String, pass: String, email: String) async throws -> UserModels.User {
        guard let mockUser else {
            throw mockError
        }
        return mockUser
    }


    func activate(code: String) async throws -> UserModels.User {
        guard let mockUser else {
            throw mockError
        }
        return mockUser
    }


    func verify(email: String) async throws {
        return
    }

    func getLocalUser() async -> UserModels.User? {
        return mockUser
    }
}
