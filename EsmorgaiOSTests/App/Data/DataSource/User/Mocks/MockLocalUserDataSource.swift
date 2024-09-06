//
//  MockLocalUserDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockLocalUserDataSource: LocalUserDataSourceProtocol {

    var savedUser: UserModels.User?

    func saveUser(_ user: UserModels.User) async throws -> () {
        savedUser = user
        return
    }

    func getUser() async -> UserModels.User? {
        return savedUser
    }
}
