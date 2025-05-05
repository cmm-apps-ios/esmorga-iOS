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


    private let navigationManager: ExternalAppsManagerProtocol

    @Published var primaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.confirmEmail.localize(),
                                                      isLoading: false)
    @Published var secondaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.resendEmail.localize(),
                                                        isLoading: false)

    @Published var showMethodsAlert: Bool = false

    private let verifyUserUseCase: VerifyUserUseCaseAlias

    private let email: String

    var navigationMethods = [NavigationModels.Method]()

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared, navigationManager: ExternalAppsManagerProtocol = ExternalAppsManager(), verifyUserUseCase: VerifyUserUseCaseAlias =  VerifyUserUseCase(), email: String) {
        self.navigationManager = navigationManager
        self.verifyUserUseCase = verifyUserUseCase
        self.email = email

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }

    func openMailApp() {
        navigationMethods = navigationManager.getMailMethods()
        if navigationMethods.count == 1, let method = navigationMethods.first {
            openNavigationMethod(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        coordinator?.openNavigationApp(method)
    }

    func resendMail() {

        secondaryButton.isLoading = true

        Task { [weak self] in
            guard let self else { return }

          //  let email = "yagoarestest15@yopmail.com" //Por probar, sigo investigando

            let result = await VerifyUserUseCase().execute(input: VerifyUserUseCaseInput(email: self.email))

            await MainActor.run {
                switch result {
                case .success:
                    self.secondaryButton.isLoading = false
                    //  self.snackBar = .init(message: LocalizationKeys.Snackbar.emailResent.localize(), isShown: true)
                case .failure(let error):
                    self.secondaryButton.isLoading = false
                    switch error {
                    case .noInternetConnection:
                        self.snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(), isShown: true)
                    default:
                        // self.snackBar = .init(message: LocalizationKeys.Snackbar.genericError.localize(), isShown: true)
                        print("Fail")
                    }
                }
            }
        }
    }
}
