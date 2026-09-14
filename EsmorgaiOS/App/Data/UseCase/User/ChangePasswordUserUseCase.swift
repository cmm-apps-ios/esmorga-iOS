//
//  ChangePasswordUserUseCase.swift
//  EsmorgaiOS
//
//  Created by MoranMarcelo on 28/8/26.
//

import Foundation

struct ChangePasswordUserUseCaseInput {
    let currentPassword: String
    let newPassword: String
}

enum ChangePasswordUserError: Error {
    case noInternetConnection
    case mappingError
    case generalError
}

typealias ChangePasswordUserResult = Result<Void, ChangePasswordUserError>
typealias ChangePasswordUserUseCaseAlias = BaseUseCase<ChangePasswordUserUseCaseInput, ChangePasswordUserResult>

class ChangePasswordUserUseCase: ChangePasswordUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: ChangePasswordUserUseCaseInput) async -> ChangePasswordUserResult {
        do {
            try await userRepository.changePassword(currentPassword: input.currentPassword, newPassword: input.newPassword)
            return .success(())
        } catch let error {
            return .failure(self.mapError(error))
        }
    }

    private func mapError(_ error: Error) -> ChangePasswordUserError {
        switch error {
        case NetworkError.noInternetConnection: return .noInternetConnection
        case NetworkError.mappingError: return .mappingError
        default: return .generalError
        }
    }
}
