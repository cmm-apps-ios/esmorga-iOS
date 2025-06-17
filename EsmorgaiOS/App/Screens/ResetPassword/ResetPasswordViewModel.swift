//
//  ResetPasswordViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/6/25.
//

import Foundation

enum ResetPasswordViewStates: ViewStateProtocol {
    case ready
}

class ResetPasswordViewModel: BaseViewModel<ActivateAccountViewStates> {

    private let resetPasswordUserUseCase: ResetPasswordUserUseCaseAlias

    @Published var textFields = [ResetPasswordModels.TextFieldModels]()

    @Published var primaryButton = RecoverPasswordModels.Button(title: LocalizationKeys.Buttons.resetPassword.localize(), isLoading: false)



    private let code: String

    var isFormValid: Bool {
        textFields.allSatisfy { tf in //true si cumple
            !tf.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && tf.errorMessage == nil
        }
        && (
            textFields.first(where: { $0.type == .pass })?.text ==
            textFields.first(where: { $0.type == .confirmPass })?.text
        )
    }

    init(coordinator: (any CoordinatorProtocol)?, resetPasswordUserUseCase: ResetPasswordUserUseCaseAlias = ResetPasswordUserUseCase(), code: String) {
        self.resetPasswordUserUseCase = resetPasswordUserUseCase
        self.code = code
        super.init(coordinator: coordinator)

        textFields =  [ResetPasswordModels.TextFieldModels(type: .pass,
                                                           text: "",
                                                           title: "Nueva Contraseña",
                                                           placeholder: LocalizationKeys.TextField.Placeholders.newPassword.localize(),
                                                           isProtected: true),
                       ResetPasswordModels.TextFieldModels(type: .confirmPass,
                                                           text: "",
                                                           title: "Repetir Contraseña",
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
    func validateTextField(type: ResetPasswordModels.TextFieldType, checkIsEmpty: Bool) -> Bool {

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

    private func getTextFieldIsValid(type: ResetPasswordModels.TextFieldType, checkIsEmpty: Bool) -> Bool {

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

    private func getTextFieldRegex(type: ResetPasswordModels.TextFieldType) -> RegexCase {
        switch type {
        case .pass, .confirmPass: return .userPassword
        }
    }

    private func getTextFieldErrorMessage(type: ResetPasswordModels.TextFieldType) -> String {
        switch type {
        case .pass: return LocalizationKeys.TextField.InlineError.passwordInvalidLong.localize()
        case .confirmPass: return LocalizationKeys.TextField.InlineError.passwordMismatch.localize()
        }
    }

    @MainActor
    func performResetPassword() {

        guard validateAllFields() else { return }
        primaryButton.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            let pass = textFields.first(where: { $0.type == .pass })?.text ?? ""

            let result = await ResetPasswordUserUseCase().execute(input: ResetPasswordUserUseCaseInput(pass: pass, code: code))

            await MainActor.run {
                switch result {
                case .success:
                    self.primaryButton.isLoading = false
                    UserDefaults.standard.set(true, forKey: "showSnackBarPassword")
                    self.coordinator?.popToRoot()
                    self.coordinator?.push(destination: .login)
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
        }
        coordinator?.push(destination: .dialog(dialogModel))
    }
}
