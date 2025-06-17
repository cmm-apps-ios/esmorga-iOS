//
//  ResetPasswordDataSource.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 10/6/25.
//

import Foundation

protocol ResetPasswordUserDataSourceProtocol {
    func resetPassword(pass: String, code: String) async throws
}


class ResetPasswordUserDataSource: ResetPasswordUserDataSourceProtocol {


    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func resetPassword(pass: String, code: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.resetPassword(pass: pass, code: code)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }
}
