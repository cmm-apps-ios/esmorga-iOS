//
//  LoginUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

protocol LoginUserDataSourceProtocol {
    func login(email: String, password: String) async throws -> AccountLoginModel.Login
}

class LoginUserDataSource: LoginUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func login(email: String, password: String) async throws -> AccountLoginModel.Login {
        do {
            let login: AccountLoginModel.Login = try await networkRequest.request(networkService: AccountNetworkService.login(pass: password, email: email))
            return login
        } catch let error {
            throw error
        }
    }
}
