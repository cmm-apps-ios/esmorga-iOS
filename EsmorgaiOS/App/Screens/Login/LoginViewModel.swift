//
//  LoginViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

enum LoginViewStates: ViewStateProtocol {
    case ready
}

class LoginViewModel: BaseViewModel<LoginViewStates> {
    @Published var emailTextField = LoginModels.TextFieldModel(text: "",
                                                               title: LocalizationKeys.TextField.Title.email.localize(),
                                                               placeholder: LocalizationKeys.TextField.Placeholders.email.localize(),
                                                               isProtected: false)

    @Published var passTextField = LoginModels.TextFieldModel(text: "",
                                                               title: LocalizationKeys.TextField.Title.password.localize(),
                                                               placeholder: LocalizationKeys.TextField.Placeholders.password.localize(),
                                                               isProtected: true)

    @Published var isLoading: Bool = false

    private let loginUseCase: LoginUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?,
        loginUseCase: LoginUseCaseAlias = LoginUseCase()) {
        self.loginUseCase = loginUseCase
        super.init(coordinator: coordinator)
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

    private func checkPassIsEmpty() -> Bool {
        if passTextField.text.isEmpty {
            passTextField.errorMessage = LocalizationKeys.TextField.InlineError.emptyField.localize()
            return true
        } else {
            passTextField.errorMessage = nil
            return false
        }
    }

    private func checkFieldsValidation() -> Bool {
        let isValidEmail = validateEmailField(checkIsEmpty: true)
        let isValidPass = validatePassField(checkIsEmpty: true)
        return isValidEmail && isValidPass
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

    @discardableResult
    func validatePassField(checkIsEmpty: Bool) -> Bool {

        passTextField.text = passTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if passTextField.text.isValid(regexPattern: .userPassword) {
            passTextField.errorMessage = nil
            return true
        } else if passTextField.text.isEmpty {
            passTextField.errorMessage = checkIsEmpty ? LocalizationKeys.TextField.InlineError.emptyField.localize() : nil
            return !checkIsEmpty
        } else {
            passTextField.errorMessage = LocalizationKeys.TextField.InlineError.password.localize()
            return false
        }
    }

    func navigateToRegister() {
        coordinator?.push(destination: .register)
    }

    func performLogin() {

        guard checkFieldsValidation()  else { return }
        self.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            let result = await loginUseCase.execute(input: LoginUseCaseInput(email: emailTextField.text, 
                                                                             password: passTextField.text))
            await MainActor.run {
                switch result {
                case .success:
                    self.isLoading = false
                    self.coordinator?.push(destination: .dashboard)
                case .failure(let error):
                    self.isLoading = false
                    switch error {
                    case NetworkError.noInternetConnection:
                        self.snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(),
                                              isShown: true)
                    default:
                        self.showErrorDialog()
                    }
                }
            }
        }
    }

    private func showErrorDialog() {
        let dialogModel = ErrorDialog.Model(image: "error_icon",
                                            message: LocalizationKeys.DefaultError.titleExpanded.localize(),
                                            buttonText: LocalizationKeys.Buttons.retry.localize(),
                                            handler: {
            self.passTextField.text = ""
            self.emailTextField.text = ""
        })
        coordinator?.push(destination: .dialog(dialogModel))
    }
}