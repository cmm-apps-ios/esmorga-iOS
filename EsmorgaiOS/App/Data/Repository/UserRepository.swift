//
//  UserRepository.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

protocol UserRepositoryProtocol {
    func login(email: String, password: String) async throws -> UserModels.User
}

class UserRepository: UserRepositoryProtocol {

    private var remoteDataSource: UserRemoteDataSourceProtocol

    init(remoteDataSource: UserRemoteDataSourceProtocol = UserRemoteDataSource()) {
        self.remoteDataSource = remoteDataSource
    }

    func login(email: String, password: String) async throws -> UserModels.User {

        do {
            let loginResponse = try await remoteDataSource.login(email: email, password: password)
            return loginResponse.profile.toDomain()
        } catch let error {
            throw error
        }
    }
}
