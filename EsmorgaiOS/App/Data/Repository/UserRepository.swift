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
    func getLocalUser() async -> UserModels.User?
}

class UserRepository: UserRepositoryProtocol {

    private var localUserDataSource: LocalUserDataSourceProtocol
    private var loginUserDataSource: LoginUserDataSourceProtocol
    private var registerUserDataSource: RegisterUserDataSourceProtocol

    init(localUserDataSource: LocalUserDataSourceProtocol = LocalUserDataSource(),
         loginUserDataSource: LoginUserDataSourceProtocol = LoginUserDataSource(),
         registerUserDataSource: RegisterUserDataSourceProtocol = RegisterUserDataSource()) {
        self.localUserDataSource = localUserDataSource
        self.loginUserDataSource = loginUserDataSource
        self.registerUserDataSource = registerUserDataSource
    }

    func login(email: String, password: String) async throws -> UserModels.User {

        do {
            let loginResponse = try await loginUserDataSource.login(email: email, password: password)
            let user = await processLogiResponse(loginResponse)
            return user
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
            let user = await processLogiResponse(loginResponse)
            return user
        } catch let error {
            throw error
        }
    }

    private func processLogiResponse(_ login: AccountLoginModel.Login) async -> UserModels.User {
        let user = login.profile.toDomain()
        try? await storeUser(user)
        return user
    }

    func getLocalUser() async -> UserModels.User? {
        let localUser = await localUserDataSource.getUser()
        return localUser
    }

    private func storeUser(_ user: UserModels.User) async throws {
        try await localUserDataSource.saveUser(user)
    }
}
