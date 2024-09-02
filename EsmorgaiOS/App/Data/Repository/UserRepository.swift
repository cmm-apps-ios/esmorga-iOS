//
//  UserRepository.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

protocol UserRepositoryProtocol {
    func login(email: String, password: String) async throws -> UserModels.User
    func register(name: String, lastName: String, pass: String, email: String) async throws -> UserModels.User
}

class UserRepository: UserRepositoryProtocol {

    private var loginUserDataSource: LoginUserDataSourceProtocol
    private var registerUserDataSource: RegisterUserDataSourceProtocol

    init(loginUserDataSource: LoginUserDataSourceProtocol = LoginUserDataSource(),
         registerUserDataSource: RegisterUserDataSourceProtocol = RegisterUserDataSource()) {
        self.loginUserDataSource = loginUserDataSource
        self.registerUserDataSource = registerUserDataSource
    }

    func login(email: String, password: String) async throws -> UserModels.User {

        do {
            let loginResponse = try await loginUserDataSource.login(email: email, password: password)
            return loginResponse.profile.toDomain()
        } catch let error {
            throw error
        }
    }

    func register(name: String, lastName: String, pass: String, email: String) async throws -> UserModels.User {

        do {
            let loginResponse = try await registerUserDataSource.register(name: name,
                                                                          lastName: lastName,
                                                                          pass: pass,
                                                                          email: email)
            return loginResponse.profile.toDomain()
        } catch let error {
            throw error
        }
    }
}
