//
//  ActivateAccountViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

enum ActivateAccountViewStates: ViewStateProtocol {
    case ready
}

class ActivateAccountViewModel: BaseViewModel<ActivateAccountViewStates> {

    @Published var button = LoginModels.Button(title: LocalizationKeys.Buttons.continueVerify.localize(),
                                               isLoading: false)

    enum ActivationResult {
        case none
        case success
        case failure
    }

    @Published var activationResult: ActivationResult = .none

    private let activateUserUseCase: ActivateUserUseCaseAlias

    private let code: String
    private var defaultErrorCount = 0
    private(set) var hasAttemptedActivation = false

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared, activateUserUseCase: ActivateUserUseCaseAlias =  ActivateUserUseCase(), code: String) {

        self.activateUserUseCase = activateUserUseCase
        self.code = code

        print("INIT con code:", code)

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }


    func activateUser() {
        button.isLoading = true
        Task { [weak self] in
            guard let self else { return }
            let result = await activateUserUseCase.execute(input: ActivateUserUseCaseInput(code: code))
            await MainActor.run {
                self.button.isLoading = false
                switch result {
                case .success:
                    self.activationResult = .success
                case .failure:
                    self.activationResult = .failure
                    self.defaultErrorCount += 1
                    if self.defaultErrorCount >= 3 {
                        self.showErrorDialog2()
                    } else {
                        self.showErrorDialog()
                    }
                }
            }
        }
    }

    func continueAction() {
        if activationResult == .success {
            coordinator?.push(destination: .dashboard)
        }
    }
    

    private func showErrorDialog() {
        let dialogModel = ErrorDialogModelBuilder.build(type: .expiredCode) {
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }

    private func showErrorDialog2() {
        let dialogModel = ErrorDialogModelBuilder.build(type: .commonError2) {
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }
}
