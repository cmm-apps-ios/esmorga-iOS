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

    func login(email: String, password: String) async throws -> UserModels.User {
        guard let mockUser else {
            throw NetworkError.genaralError(code: 500)
        }
        return mockUser
    }
}
