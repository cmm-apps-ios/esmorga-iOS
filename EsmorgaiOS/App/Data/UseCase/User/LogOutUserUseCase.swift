//
//  LogOutUserUseCase.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 23/2/25.
//

import Foundation

enum LogOutUserError: Error {
   case logOutFailed
}

typealias LogoutUserResult = Result<Void, LogOutUserError>
typealias LogoutUserUseCaseAlias = BaseUseCase<Void, LogoutUserResult>

class LogoutUserUseCase: LogoutUserUseCaseAlias {

    private var userRepository: UserRepositoryProtocol

    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }

    override func job() async -> LogoutUserResult {
        let result = await userRepository.logoutUser()
        return result ? .success(()) : .failure(.logOutFailed) //Que tipo de error puedo generar aquí?
    }
}
