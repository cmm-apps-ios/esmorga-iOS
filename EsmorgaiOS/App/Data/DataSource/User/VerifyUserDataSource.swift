//
//  VerifyUserDataSource.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/4/25.
//

import Foundation

protocol VerifyUserDataSourceProtocol {
    func verify(email: String) async throws
}


class VerifyUserDataSource: VerifyUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func verify(email: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.verify(email: email)) as NetworkRequest.EmptyBodyObject

        } catch let error {
            throw error
        }
    }
}
