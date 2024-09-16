//
//  SplashViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/8/24.
//

import Foundation

enum SplashViewStates: ViewStateProtocol {
    case ready
    case loggedIn
    case loggedOut
}

class SplashViewModel: BaseViewModel<SplashViewStates> {

    private let getLocalUserUseCase: GetLocalUserUseCaseAlias

    init(coordinator: any CoordinatorProtocol,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator)
    }

    func getUserStatus() async {
        
        let result = await getLocalUserUseCase.execute()
        switch result {
        case .success:
            changeState(.loggedIn)
        case .failure:
            changeState(.loggedOut)
        }
    }
}
