//
//  MockActivateAccountUserDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 26/5/25.
//

import Foundation

@testable import EsmorgaiOS

final class MockActivateUserDataSource: ActivateUserDataSourceProtocol {

    var mockLogin: AccountLoginModel.Login?
    var mockError: NetworkError = NetworkError.generalError(code: 500)

    func activate(code: String) async throws -> AccountLoginModel.Login {
        guard let mockLogin else {
            throw mockError
        }
        return mockLogin
    }
}
