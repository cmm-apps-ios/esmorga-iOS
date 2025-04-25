//
//  RegistrationConfirmViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/4/25.
//

import Foundation
import UIKit

enum RegsitrationConfirmViewStates: ViewStateProtocol {
    case ready
}

class RegistrationConfirmViewModel: BaseViewModel<RegistrationViewStates> {


    private let navigationManager: NavigationManagerProtocol

    @Published var primaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.confirmEmail.localize(),
                                                      isLoading: false)
    @Published var secondaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.resendEmail.localize(),
                                                        isLoading: false)

    @Published var showMethodsAlert: Bool = false

    var navigationMethods = [NavigationModels.Method]()

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared, navigationManager: NavigationManagerProtocol = NavigationManager()) {
        self.navigationManager = navigationManager

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }

    func openMailApp() {
        navigationMethods = navigationManager.getMailApps()

        if navigationMethods.count == 1, let method = navigationMethods.first {
            openNavigationMethod(method)
        } else if navigationMethods.isEmpty {
            print("asjfdjashfhajsk")
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        coordinator?.openNavigationApp(method)
    }

    func resendMail() {


    }
}
