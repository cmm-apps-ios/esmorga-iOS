//
//  RegisterUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import Foundation

protocol RegisterUserDataSourceProtocol {
    func register(name: String, lastName: String, pass: String, email: String) async throws -> AccountLoginModel.Login
}

class RegisterUserDataSource: RegisterUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func register(name: String, lastName: String, pass: String, email: String) async throws -> AccountLoginModel.Login {

        do {
            let service = AccountNetworkService.register(name: name,
                                                         lastName: lastName,
                                                         pass: pass,
                                                         email: email)
            let login: AccountLoginModel.Login = try await networkRequest.request(networkService: service)
            return login
        } catch let error {
            throw error
        }
    }
}
