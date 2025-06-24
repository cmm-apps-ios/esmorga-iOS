//
//  MockResetPaswordUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/6/25.
//

import Foundation
@testable import EsmorgaiOS

final class ResetPasswordUserUseCase: ResetPasswordUserUseCaseAlias {

    var mockResult: Bool = true
    var mockError: ResetPasswordUserError = .generalError

    override func job(input: ResetPasswordUserUseCaseInput) async -> ResetPasswordUserResult {
        if mockResult {
            return .success(())
        } else {
            return .failure(mockError)
        }
    }
}
