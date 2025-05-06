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
    func verify(email: String) async throws
    func getLocalUser() async -> UserModels.User?
    func logoutUser() async -> Bool
}

class UserRepository: UserRepositoryProtocol {
    private var localUserDataSource: LocalUserDataSourceProtocol
    private var loginUserDataSource: LoginUserDataSourceProtocol
    private var registerUserDataSource: RegisterUserDataSourceProtocol
    private var verifyUserDataSource: VerifyUserDataSourceProtocol
    private var localEventsDataSource: LocalEventsDataSourceProtocol
    private var sessionKeychain: CodableKeychain<AccountSession>

    init(localUserDataSource: LocalUserDataSourceProtocol = LocalUserDataSource(),
         loginUserDataSource: LoginUserDataSourceProtocol = LoginUserDataSource(),
         registerUserDataSource: RegisterUserDataSourceProtocol = RegisterUserDataSource(),
         verifyUserDataSource: VerifyUserDataSourceProtocol = VerifyUserDataSource(),
         localEventsDataSource: LocalEventsDataSourceProtocol = LocalEventsDataSource(),
         sessionKeychain: CodableKeychain<AccountSession> = AccountSession.buildCodableKeychain()) {
        self.localUserDataSource = localUserDataSource
        self.loginUserDataSource = loginUserDataSource
        self.registerUserDataSource = registerUserDataSource
        self.verifyUserDataSource = verifyUserDataSource
        self.localEventsDataSource = localEventsDataSource
        self.sessionKeychain = sessionKeychain
    }

    func login(email: String, password: String) async throws -> UserModels.User {

        do {
            let loginResponse = try await loginUserDataSource.login(email: email, password: password)
            let user = await processLoginResponse(loginResponse)
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
            let user = await processLoginResponse(loginResponse)
            return user
        } catch let error {
            throw error
        }
    }

    func verify(email: String) async throws {
        do {
            try await verifyUserDataSource.verify(email: email)
        } catch let error {
            throw error
        }
    }

    private func processLoginResponse(_ login: AccountLoginModel.Login) async -> UserModels.User {
        let user = login.profile.toDomain()
        try? await storeUser(user)
        let session = AccountSession(accessToken: login.accessToken,
                                     refreshToken: login.refreshToken,
                                     ttl: Double(login.ttl))
        try? storeSession(session)
        deleteEventsData()
        return user
    }

    func getLocalUser() async -> UserModels.User? {
        let localUser = await localUserDataSource.getUser()
        return localUser
    }

    private func storeUser(_ user: UserModels.User) async throws {
        try await localUserDataSource.saveUser(user)
    }

    func logoutUser() async -> Bool {
        do {
            try sessionKeychain.delete()
            localUserDataSource.clearAll()
            deleteEventsData()
            return true
        } catch {
            return false
        }
    }

    private func storeSession(_ session: AccountSession) throws {
        try sessionKeychain.store(codable: session)
    }

    private func deleteEventsData() {
        localEventsDataSource.clearAll()
    }
}
