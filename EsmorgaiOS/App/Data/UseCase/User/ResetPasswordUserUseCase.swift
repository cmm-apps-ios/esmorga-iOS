//
//  ResetPasswordUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 10/6/25.
//

import Foundation

struct ResetPasswordUserUseCaseInput {
    let pass: String
    let code: String
}

enum ResetPasswordUserError: Error {
    case noInternetConnection
    case mappingError
    case generalError
}

typealias ResetPasswordUserResult = Result<Void, ResetPasswordUserError>
typealias ResetPasswordUserUseCaseAlias = BaseUseCase<ResetPasswordUserUseCaseInput, ResetPasswordUserResult>

class ResetPasswordUserUseCase: ResetPasswordUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
/*
    override func job(input: RecoverPasswordUserUseCaseInput) async -> RecoverPasswordUserResult {
        do {
            try await userRepository.recoverPassword(email: input.email)
            return .success(())
        } catch let error {
            return .failure(self.mapError(error))
        }
    }
*/
    private func mapError(_ error: Error) -> ResetPasswordUserError {

        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        default: return .generalError
        }
    }
}
