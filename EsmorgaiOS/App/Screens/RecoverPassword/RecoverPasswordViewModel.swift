//
//  RecoverPasswordView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 3/6/25.
//

import Foundation

enum RecoverPasswordViewStates: ViewStateProtocol {
    case ready
}

class RecoverPasswordViewModel: BaseViewModel<RecoverPasswordViewStates> {

    @Published var emailTextField = RecoverPasswordModels.TextFieldModel(text: "",
                                                                         title: LocalizationKeys.TextField.Title.email.localize(),
                                                                         placeholder: "Introduce tu email")

    @Published var primaryButton = RecoverPasswordModels.Button(title: "Enviar",
                                                                isLoading: false)

    private let recoverPasswordUserUseCase: RecoverPasswordUserUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared,  recoverPasswordUserUseCase: RecoverPasswordUserUseCaseAlias =  RecoverPasswordUserUseCase()) {
        self.recoverPasswordUserUseCase = recoverPasswordUserUseCase

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }



    private func checkEmailIsEmpty() -> Bool {
        if emailTextField.text.isEmpty {
            emailTextField.errorMessage = LocalizationKeys.TextField.InlineError.emptyField.localize()
            return true
        } else {
            emailTextField.errorMessage = nil
            return false
        }
    }

    private func checkFieldsValidation() -> Bool {
        let isValidEmail = validateEmailField(checkIsEmpty: true)
        return isValidEmail
    }

    @discardableResult
    func validateEmailField(checkIsEmpty: Bool) -> Bool {

        emailTextField.text = emailTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailTextField.text.isValid(regexPattern: .userEmail) {
            emailTextField.errorMessage = nil
            return true
        } else if emailTextField.text.isEmpty {
            emailTextField.errorMessage = checkIsEmpty ? LocalizationKeys.TextField.InlineError.emptyField.localize() : nil
            return !checkIsEmpty
        } else {
            emailTextField.errorMessage = LocalizationKeys.TextField.InlineError.email.localize()
            return false
        }
    }

    func sendMailForgotPass() {
        guard checkFieldsValidation()  else { return }
        primaryButton.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            let result = await recoverPasswordUserUseCase.execute(input: RecoverPasswordUserUseCaseInput(email: emailTextField.text))
            await MainActor.run {
                switch result {
                case .success:
                    self.primaryButton.isLoading = false
                    self.snackBar = .init(message: "Email de recuperación enviado", isShown: true)
                case .failure(let error):
                    self.primaryButton.isLoading = false
                    switch error {
                    default:
                        self.showErrorDialog()
                    }
                }
            }
        }
    }

    private func showErrorDialog() {
        let dialogModel = ErrorDialogModelBuilder.build(type: .commonError) {
            self.emailTextField.text = ""
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }
}
