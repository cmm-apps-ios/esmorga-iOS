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
                                                               title: Localize.localize(key: LocalizationKeys.Login.emailTitle),
                                                               placeholder: "Introduce tu email",
                                                               isProtected: false)

    @Published var passTextField = LoginModels.TextFieldModel(text: "",
                                                               title: Localize.localize(key: LocalizationKeys.Login.passwordTitle),
                                                               placeholder: "Introduce tu contraseña",
                                                               isProtected: true)

    @Published var isLoading: Bool = false

    private let loginUseCase: LoginUseCaseAlias
    private let router: LoginRouterProtocol

    init(loginUseCase: LoginUseCaseAlias = LoginUseCase(),
         router: LoginRouterProtocol) {
        self.loginUseCase = loginUseCase
        self.router = router
    }

    @discardableResult
    func validateEmail() -> Bool {
        emailTextField.text = emailTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)
        if emailTextField.text.isValid(regexPattern: .userEmail) {
            emailTextField.errorMessage = nil
            return true
        } else {
            emailTextField.errorMessage = emailTextField.text.isEmpty ?
            Localize.localize(key: LocalizationKeys.Login.emptyTextField) :
            Localize.localize(key: LocalizationKeys.Login.invalidEmailText)
            return false
        }
    }

    @discardableResult
    func validatePass() -> Bool {
        passTextField.text = passTextField.text.trimmingCharacters(in: .whitespacesAndNewlines)

        if passTextField.text.isValid(regexPattern: .userPassword) {
            passTextField.errorMessage = nil
            return true
        } else {
            passTextField.errorMessage = passTextField.text.isEmpty ?
            Localize.localize(key: LocalizationKeys.Login.emptyTextField) :
            Localize.localize(key: LocalizationKeys.Login.invalidPasswordText)
            return false
        }
    }

    func performLogin() {

        let isValidEmail = validateEmail()
        let isValidPass = validatePass()

        guard isValidEmail && isValidPass else { return }

        self.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            let result = await loginUseCase.execute(input: LoginUseCaseInput(email: emailTextField.text, 
                                                                             password: passTextField.text))
            await MainActor.run {
                switch result {
                case .success:
                    self.isLoading = false
                    self.router.navigateToList()
                case .failure(let error):
                    self.isLoading = false
                    switch error {
                    case NetworkError.noInternetConnection:
                        self.snackBar = .init(message: Localize.localize(key: LocalizationKeys.CommonKeys.noConnectionText),
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
                                            message: Localize.localize(key: LocalizationKeys.CommonKeys.errorTitle),
                                            buttonText: Localize.localize(key: LocalizationKeys.CommonKeys.errorButtonText),
                                            handler: {
            self.passTextField.text = ""
            self.emailTextField.text = ""
        })
        router.navigateToErrorDialog(model: dialogModel)
    }
}
