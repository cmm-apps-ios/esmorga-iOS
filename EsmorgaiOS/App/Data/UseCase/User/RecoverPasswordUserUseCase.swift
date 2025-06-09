//
//  RecoverPasswordUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 4/6/25.
//

import Foundation

struct RecoverPasswordUserUseCaseInput {
    let email: String
}

enum RecoverPasswordUserError: Error {
    case noInternetConnection
    case mappingError
    case generalError
}

typealias RecoverPasswordUserResult = Result<Void, RecoverPasswordUserError>
typealias RecoverPasswordUserUseCaseAlias = BaseUseCase<RecoverPasswordUserUseCaseInput, RecoverPasswordUserResult>

class RecoverPasswordUserUseCase: RecoverPasswordUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: RecoverPasswordUserUseCaseInput) async -> RecoverPasswordUserResult {
        do {
            try await userRepository.recoverPassword(email: input.email)
            return .success(())
        } catch let error {
            return .failure(self.mapError(error))
        }
    }

    private func mapError(_ error: Error) -> RecoverPasswordUserError {

        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        default: return .generalError
        }
    }
}
