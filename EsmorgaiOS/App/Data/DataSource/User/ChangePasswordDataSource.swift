//
//  ChangePasswordDataSource.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 31/08/2026.
//

import Foundation

protocol ChangePasswordUserDataSourceProtocol {
    func changePassword(currentPassword: String, newPassword: String) async throws
}

class ChangePasswordUserDataSource: ChangePasswordUserDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func changePassword(currentPassword: String, newPassword: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.changePassword(currentPassword: currentPassword, newPassword: newPassword)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }
}
