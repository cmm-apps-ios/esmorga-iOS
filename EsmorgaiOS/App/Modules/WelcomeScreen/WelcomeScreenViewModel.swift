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

    private let router: WelcomeScreenRouterProtocol

    init(router: WelcomeScreenRouterProtocol) {
        self.router = router
    }

    func loginButtonTapped() {
        router.navigateToLoggin()
    }

    func enterAsGuestTapped() {
        router.navigateToEventList()
    }
}
