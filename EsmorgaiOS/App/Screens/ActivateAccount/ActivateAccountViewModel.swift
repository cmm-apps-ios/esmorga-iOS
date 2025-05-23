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

    private let activateUserUseCase: ActivateUserUseCaseAlias

    private let code: String
    private var defaultErrorCount = 0

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
                switch result {
                case .success:
                    self.button.isLoading = false
                    self.coordinator?.push(destination: .dashboard)
                case .failure(let error):
                    self.button.isLoading = false
                    switch error {
                    case NetworkError.noInternetConnection:
                        print("No internet, pero quiza no lo contemplo") //temporal porque la US no lo pide
                    default:
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
