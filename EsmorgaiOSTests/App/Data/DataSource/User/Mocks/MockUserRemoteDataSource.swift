//
//  MockUserRemoteDataSource.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockLoginUserDataSource: LoginUserDataSourceProtocol {

    var mockLogin: AccountLoginModel.Login?
    var mockError: NetworkError = NetworkError.generalError(code: 500)

    func login(email: String, password: String) async throws -> AccountLoginModel.Login {
        guard let mockLogin else {
            throw mockError
        }
        return mockLogin
    }
}
