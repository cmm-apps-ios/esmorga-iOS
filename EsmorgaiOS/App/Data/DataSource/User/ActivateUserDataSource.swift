//
//  ActivateUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 20/5/25.
//

import Foundation


protocol ActivateUserDataSourceProtocol {
    func activate(code: String) async throws -> AccountLoginModel.Login
}

class ActivateUserDataSource: ActivateUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }


    func activate(code: String) async throws -> AccountLoginModel.Login {
        do {
            let login: AccountLoginModel.Login = try await networkRequest.request(networkService: AccountNetworkService.activate(code: code))
            return login
        } catch let error {
            throw error
        }
    }
}


