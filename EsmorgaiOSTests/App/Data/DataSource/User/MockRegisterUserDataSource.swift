//
//  MockRegisterUserDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockRegisterUserDataSource: RegisterUserDataSourceProtocol {

    var mockLogin: AccountLoginModel.Login?
    var mockError: NetworkError = NetworkError.generalError(code: 500)

    func register(name: String, lastName: String, pass: String, email: String) async throws -> AccountLoginModel.Login {
        guard let mockLogin else {
            throw mockError
        }
        return mockLogin
    }
}
