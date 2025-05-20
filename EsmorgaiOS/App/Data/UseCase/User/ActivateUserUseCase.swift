//
//  ActivateUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 20/5/25.
//

import Foundation

struct ActivateUseCaseInput {
    let code: String
}

typealias ActivateResult = Result<UserModels.User, Error>
typealias ActivateUseCaseAlias = BaseUseCase<ActivateUseCaseInput, ActivateResult>

class ActivateUseCase: ActivateUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job(input: ActivateUseCaseInput) async -> ActivateResult {
        do {
            let user = try await userRepository.activate(code: input.code)
            return .success(user)
        } catch let error {
            return .failure(error)
        }
    }
}

