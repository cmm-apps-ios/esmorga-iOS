//
//  MockVerifyUserUseCase.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 10/5/25.
//

import Foundation
@testable import EsmorgaiOS

final class MockVerifyUserUseCase: VerifyUserUseCaseAlias {
    
    var mockResult: Bool = true
    var mockError: VerifyUserError = .generalError
    
    override func job(input: VerifyUserUseCaseInput) async -> VerifyUserResult {
        if mockResult {
            return .success(())
        } else {
            return .failure(mockError)
        }
    }
}
