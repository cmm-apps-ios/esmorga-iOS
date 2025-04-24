//
//  VerifyUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/4/25.
//

import Foundation

protocol VerifyUserDataSourceProtocol {
    func verify(email: String) async throws -> AccountLoginModel.Login
}


class VerifyUserDataSource: VerifyUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func verify(email: String) async throws -> AccountLoginModel.Login {

        do {
            let service = AccountNetworkService.verify(email: email)
            let login: AccountLoginModel.Login = try await networkRequest.request(networkService: service)
            return login
        } catch let error {
            throw error
        }
    }
}


