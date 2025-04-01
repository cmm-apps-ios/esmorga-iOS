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

    @Published var model = WelcomeScreenModels.Model(imageName: "esmorga",
                                                     primaryButtonText: LocalizationKeys.Buttons.loginRegister.localize(),
                                                     secondaryButtonText: LocalizationKeys.Buttons.guest.localize())

    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }

    func enterAsGuestTapped() {
        // coordinator?.push(destination: .dashboard)
        let numbers = [0]
        let _ = numbers[1]

    }
}
