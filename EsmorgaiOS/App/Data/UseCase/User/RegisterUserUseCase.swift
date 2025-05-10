//
//  RegisterUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import Foundation

struct RegisterUserUseCaseInput {
    let name: String
    let lastName: String
    let email: String
    let password: String
}

enum RegisterUserError: Error {
    case userRegister
    case noInternetConnection
    case mappingError
    case generalError
    case needsConfirmation
}

typealias RegisterUserResult = Result<UserModels.User, RegisterUserError>
typealias RegisterUserUseCaseAlias = BaseUseCase<RegisterUserUseCaseInput, RegisterUserResult>

class RegisterUserUseCase: RegisterUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: RegisterUserUseCaseInput) async -> RegisterUserResult {
        do {
            let user = try await userRepository.register(name: input.name,
                                                         lastName: input.lastName,
                                                         pass: input.password,
                                                         email: input.email)
            return .success(user)
        } catch let error {
            return .failure(self.mapError(error))
        }
    }

    private func mapError(_ error: Error) -> RegisterUserError {

        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        case NetworkError.generalError(let code) where code == 409: return .userRegister
        case NetworkError.generalError(let code) where code == 201: return .needsConfirmation
        default: return .generalError
        }
    }
}
