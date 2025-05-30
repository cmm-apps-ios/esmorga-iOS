//
//  VerifyUserUserCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/4/25.
//

import Foundation

struct VerifyUserUseCaseInput {
    let email: String
}

enum VerifyUserError: Error {
    case noInternetConnection
    case mappingError
    case generalError
}

typealias VerifyUserResult = Result<Void, VerifyUserError>
typealias VerifyUserUseCaseAlias = BaseUseCase<VerifyUserUseCaseInput, VerifyUserResult>

class VerifyUserUseCase: VerifyUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }


    override func job(input: VerifyUserUseCaseInput) async -> VerifyUserResult {
        do {
            try await userRepository.verify(email: input.email)
            return .success(())
        } catch let error {
            return .failure(self.mapError(error))
        }
    }

    private func mapError(_ error: Error) -> VerifyUserError {

        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        default: return .generalError
        }
    }

}
