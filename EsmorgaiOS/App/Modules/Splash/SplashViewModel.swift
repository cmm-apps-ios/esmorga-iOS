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

    func getUserStatus() {
        changeState(.loggedOut)
    }
}
