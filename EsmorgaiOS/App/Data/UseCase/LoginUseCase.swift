//
//  LoginUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

struct LoginUseCaseInput {
    let email: String
    let password: String
}

typealias LoginResult = Result<UserModels.User, Error>
typealias LoginUseCaseAlias = BaseUseCase<LoginUseCaseInput, LoginResult>

class LoginUseCase: LoginUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: LoginUseCaseInput) async -> LoginResult {
        do {
            let user = try await userRepository.login(email: input.email, password: input.password)
            return .success(user)
        } catch let error {
            return .failure(error)
        }
    }
}
