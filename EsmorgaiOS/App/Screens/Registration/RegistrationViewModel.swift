//
//  RegistrationViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import Foundation

enum RegistrationViewStates: ViewStateProtocol {
    case ready
}

class RegistrationViewModel: BaseViewModel<RegistrationViewStates> {

    private let registerUserUseCase: RegisterUserUseCaseAlias
    //    weak var coordinator: Coordinator?

    @Published var textFields = [RegisterModels.TextFieldModels]()
    @Published var button = RegisterModels.Button(title: LocalizationKeys.Buttons.createAccount.localize(),
                                                  isLoading: false)

    init(coordinator: (any CoordinatorProtocol)?,
         registerUserUseCase: RegisterUserUseCaseAlias = RegisterUserUseCase()) {
        self.registerUserUseCase = registerUserUseCase
        super.init(coordinator: coordinator)

        textFields = [RegisterModels.TextFieldModels(type: .name,
                                                     text: "",
                                                     title: LocalizationKeys.TextField.Title.name.localize(),
                                                     placeholder: LocalizationKeys.TextField.Placeholders.name.localize(),
                                                     isProtected: false),
                      RegisterModels.TextFieldModels(type: .lastName,
                                                     text: "",
                                                     title: LocalizationKeys.TextField.Title.lastName.localize(),
                                                     placeholder: LocalizationKeys.TextField.Placeholders.lastName.localize(),
                                                     isProtected: false),
                      RegisterModels.TextFieldModels(type: .email,
                                                     text: "",
                                                     title: LocalizationKeys.TextField.Title.email.localize(),
                                                     placeholder: LocalizationKeys.TextField.Placeholders.email.localize(),
                                                     isProtected: false),
                      RegisterModels.TextFieldModels(type: .pass,
                                                     text: "",
                                                     title: LocalizationKeys.TextField.Title.password.localize(),
                                                     placeholder: LocalizationKeys.TextField.Placeholders.password.localize(),
                                                     isProtected: true),
                      RegisterModels.TextFieldModels(type: .confirmPass,
                                                     text: "",
                                                     title: LocalizationKeys.TextField.Title.repeatPassword.localize(),
                                                     placeholder: LocalizationKeys.TextField.Placeholders.confirmPassword.localize(),
                                                     isProtected: true)]
    }

    private func validateAllFields() -> Bool {
        var isValid: Bool = true
        for textField in textFields {
            if !validateTextField(type: textField.type, checkIsEmpty: true) {
                isValid = false
            }
        }
        return isValid
    }

    @discardableResult
    func validateTextField(type: RegisterModels.TextFieldType, checkIsEmpty: Bool) -> Bool {

        guard let index = textFields.firstIndex(where: { $0.type == type }) else { return false }
        textFields[index].text = textFields[index].text.trimmingCharacters(in: .whitespacesAndNewlines)

        if getTextFieldIsValid(type: type, checkIsEmpty: checkIsEmpty) {
            textFields[index].errorMessage = nil
            return true
        } else if textFields[index].text.isEmpty {
            textFields[index].errorMessage = checkIsEmpty ? LocalizationKeys.TextField.InlineError.emptyField.localize() : nil
            return !checkIsEmpty
        } else {
            textFields[index].errorMessage = getTextFieldErrorMessage(type: type)
            return false
        }
    }

    private func getTextFieldIsValid(type: RegisterModels.TextFieldType, checkIsEmpty: Bool) -> Bool {

        guard let index = textFields.firstIndex(where: { $0.type == type }) else { return false }
        if type == .confirmPass {
            if checkIsEmpty && textFields[index].text.isEmpty {
                return false
            } else {
                guard let passTextIndex = textFields.firstIndex(where: { $0.type == .pass }) else { return false }
                return textFields[passTextIndex].text == textFields[index].text
            }
        } else {
            return textFields[index].text.isValid(regexPattern: getTextFieldRegex(type: type))
        }
    }

    private func getTextFieldRegex(type: RegisterModels.TextFieldType) -> RegexCase {
        switch type {
        case .name, .lastName: return .userName
        case .email: return .userEmail
        case .pass, .confirmPass: return .userPassword
        }
    }

    private func getTextFieldErrorMessage(type: RegisterModels.TextFieldType) -> String {
        switch type {
        case .name: return LocalizationKeys.TextField.InlineError.name.localize()
        case .lastName: return LocalizationKeys.TextField.InlineError.lastName.localize()
        case .email: return LocalizationKeys.TextField.InlineError.email.localize()
        case .pass: return LocalizationKeys.TextField.InlineError.password.localize()
        case .confirmPass: return LocalizationKeys.TextField.InlineError.passwordMismatch.localize()
        }
    }

    func performRegistration() {

        guard validateAllFields() else { return }
        button.isLoading = true

        Task { [weak self] in
            guard let self else { return }

            let name = textFields.first(where: { $0.type == .name })?.text ?? ""
            let lastName = textFields.first(where: { $0.type == .lastName })?.text ?? ""
            let email = textFields.first(where: { $0.type == .email })?.text ?? ""
            let pass = textFields.first(where: { $0.type == .pass })?.text ?? ""

            let result = await registerUserUseCase.execute(input: RegisterUserUseCaseInput(name: name,
                                                                                           lastName: lastName,
                                                                                           email: email,
                                                                                           password: pass))
            await MainActor.run {
                switch result {
                case .success:
                    self.button.isLoading = false
                    self.coordinator?.push(destination: .dashboard)
                case .failure(let error):
                    self.button.isLoading = false
                    switch error {
                    case .noInternetConnection:
                        self.snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(),
                                              isShown: true)
                    case .userRegister:
                        self.setEmailUserError()
                    default: self.showErrorDialog()
                    }
                }
            }

        }
    }

    private func setEmailUserError() {
        guard let index = textFields.firstIndex(where: { $0.type == .email }) else { return }
        textFields[index].errorMessage = LocalizationKeys.TextField.InlineError.emailAlreadyUsed.localize()
    }

    private func showErrorDialog() {
        let dialogModel = ErrorDialogModelBuilder.build(type: .commonError) {
            self.textFields.resetAllTextFields()
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }
}
