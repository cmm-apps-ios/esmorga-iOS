//
//  GetLocalUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Foundation

typealias GetLocalUserResult = Result<UserModels.User, DomainError>
typealias GetLocalUserUseCaseAlias = BaseUseCase<Void, GetLocalUserResult>

class GetLocalUserUseCase: GetLocalUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job() async -> GetLocalUserResult {
        guard let user = await userRepository.getLocalUser() else {
            return .failure(.noCacheContent)
        }
        return .success(user)
    }
}
