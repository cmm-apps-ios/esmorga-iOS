//
//  RecoverPasswordUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 4/6/25.
//

import Foundation

protocol RecoverPasswordUserDataSourceProtocol {
    func recoverPassword(email: String) async throws
}


class RecoverPasswordUserDataSource: RecoverPasswordUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func recoverPassword(email: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.forgotPassword(email: email)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }
}
