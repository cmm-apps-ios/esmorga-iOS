//
//  WelcomeScreenViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import Foundation
import SwiftUI

enum WelcomeScreenViewStates: ViewStateProtocol {
    case ready
}

class WelcomeScreenViewModel: BaseViewModel<WelcomeScreenViewStates> {

    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }

    func enterAsGuestTapped() {
        coordinator?.push(destination: .dashboard)
    }
}
