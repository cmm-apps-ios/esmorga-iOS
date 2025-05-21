//
//  ActivateUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 20/5/25.
//

import Foundation

struct ActivateUserUseCaseInput {
    let code: String
}

enum ActivateUserError: Error {
    case noInternetConnection
    case generalError
}

typealias ActivateResult = Result<UserModels.User, Error>
typealias ActivateUserUseCaseAlias = BaseUseCase<ActivateUserUseCaseInput, ActivateResult>

class ActivateUserUseCase: ActivateUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: ActivateUserUseCaseInput) async -> ActivateResult {
        do {
            let user = try await userRepository.activate(code: input.code)
            return .success(user)
        } catch let error {
            return .failure(self.mapError(error))
        }
    }

    private func mapError(_ error: Error) -> RegisterUserError {

        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        default: return .generalError
        }
    }


}

