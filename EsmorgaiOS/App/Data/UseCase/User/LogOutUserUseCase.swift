//
//  LogOutUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 23/2/25.
//

import Foundation

typealias LogoutUserResult = Result<Void, DomainError>
typealias LogoutUserUseCaseAlias = BaseUseCase<Void, LogoutUserResult>

class LogoutUserUseCase: LogoutUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job() async -> LogoutUserResult {
        let result = userRepository.logoutUser()
        return result ? .success(()) : .failure(.noCacheContent) //Que tipo de error puedo generar aquí?
    }
}
