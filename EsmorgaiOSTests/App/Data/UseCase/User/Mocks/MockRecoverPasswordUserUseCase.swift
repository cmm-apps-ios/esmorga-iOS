//
//  MockRecoverPasswordUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/6/25.
//

import Foundation
@testable import EsmorgaiOS

final class RecoverPasswordUserUseCase: RecoverPasswordUserUseCaseAlias {

    var mockResult: Bool = true
    var mockError: RecoverPasswordUserError = .generalError

    override func job(input: RecoverPasswordUserUseCaseInput) async -> RecoverPasswordUserResult {
        if mockResult {
            return .success(())
        } else {
            return .failure(mockError)
        }
    }
}
