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


    private let deepLinkManager: ExternalAppsManagerProtocol

    @Published var primaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.confirmEmail.localize(),
                                                      isLoading: false)
    @Published var secondaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.resendEmail.localize(),
                                                        isLoading: false)

    @Published var showMethodsAlert: Bool = false

    private let verifyUserUseCase: VerifyUserUseCaseAlias

    private let email: String

    var mailMethods = [DeepLinkModels.Method]()

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared, navigationManager: ExternalAppsManagerProtocol = ExternalAppsManager(), verifyUserUseCase: VerifyUserUseCaseAlias =  VerifyUserUseCase(), email: String) {
        self.deepLinkManager = navigationManager
        self.verifyUserUseCase = verifyUserUseCase
        self.email = email

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }

    func openMailApp() {
        mailMethods = deepLinkManager.getMailMethods()
        if mailMethods.count == 1, let method = mailMethods.first {
            openMailMethod(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openMailMethod(_ method: DeepLinkModels.Method) {
        coordinator?.openExtrenalApp(method)
    }

    func resendMail() {

        secondaryButton.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            
            let result = await VerifyUserUseCase().execute(input: VerifyUserUseCaseInput(email: self.email))
            await MainActor.run {
                switch result {
                case .success:
                    self.secondaryButton.isLoading = false
                    self.snackBar = .init(message: LocalizationKeys.Snackbar.resendEmail.localize(), isShown: true)
                case .failure(let error):
                    self.secondaryButton.isLoading = false
                    switch error {
                    case .noInternetConnection:
                        self.snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(), isShown: true)
                    default:
                        self.snackBar = .init(message: LocalizationKeys.Snackbar.resendEmailFailed.localize(), isShown: true)
                    }
                }
            }
        }
    }
}
