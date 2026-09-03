//
//  ChangePasswordViewModel.swift
//  EsmorgaiOS
//
//  Created by Moran, Marcelo on 27/8/26.
//

import Foundation

enum ChangePasswordViewStates: ViewStateProtocol {
    case ready
}

class ChangePasswordViewModel: BaseViewModel<ActivateAccountViewStates> {

    private let changePasswordUserUseCase: ChangePasswordUserUseCaseAlias

    @Published var textFields = [ChangePasswordModels.TextFieldModels]()
    @Published var primaryButton = RecoverPasswordModels.Button(title: LocalizationKeys.Buttons.changePassword.localize(), isLoading: false)


    var isFormValid: Bool {
        textFields.allSatisfy { tf in //true si cumple
            !tf.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && tf.errorMessage == nil
        }
        && (
            textFields.first(where: { $0.type == .pass })?.text ==
            textFields.first(where: { $0.type == .confirmPass })?.text
            &&
            textFields.first(where: { $0.type == .oldPass })?.text !=
            textFields.first(where: { $0.type == .pass })?.text
        )
    }

    init(coordinator: (any CoordinatorProtocol)?,
         changePasswordUserUseCase: ChangePasswordUserUseCaseAlias = ChangePasswordUserUseCase()) {
        self.changePasswordUserUseCase = changePasswordUserUseCase
        super.init(coordinator: coordinator)

        textFields =  [
            ChangePasswordModels.TextFieldModels(
                type: .oldPass,
                text: "",
                title: LocalizationKeys.TextField.Title.password.localize(),
                placeholder: LocalizationKeys.TextField.Placeholders.password.localize(),
                isProtected: true),
            ChangePasswordModels.TextFieldModels(
                type: .pass,
                text: "",
                title: LocalizationKeys.TextField.Title.newPassword.localize(),
                placeholder: LocalizationKeys.TextField.Placeholders.newPassword.localize(),
                isProtected: true),
            ChangePasswordModels.TextFieldModels(
                type: .confirmPass,
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
    func validateTextField(type: ChangePasswordModels.TextFieldType, checkIsEmpty: Bool) -> Bool {

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
    
    private func getTextFieldIsValid(type: ChangePasswordModels.TextFieldType,
                                     checkIsEmpty: Bool) -> Bool {

        guard let index = textFields.firstIndex(where: { $0.type == type }) else {
            return false
        }

        switch type {

        case .confirmPass:
            if checkIsEmpty && textFields[index].text.isEmpty {
                return false
            }

            guard let passIndex = textFields.firstIndex(where: { $0.type == .pass }) else {
                return false
            }

            return textFields[passIndex].text == textFields[index].text

        case .pass:
            let passwordValid = textFields[index].text.isValid(regexPattern: .userPassword)

            guard let oldPassIndex = textFields.firstIndex(where: { $0.type == .oldPass }) else {
                return passwordValid
            }

            let isDifferentFromOld =
                textFields[index].text != textFields[oldPassIndex].text

            return passwordValid && isDifferentFromOld

        case .oldPass:
            return textFields[index].text.isValid(regexPattern: .userPassword)
        }
    }

    private func getTextFieldRegex(type: ChangePasswordModels.TextFieldType) -> RegexCase {
        switch type {
        case .oldPass, .pass, .confirmPass: return .userPassword
        }
    }

    private func getTextFieldErrorMessage(type: ChangePasswordModels.TextFieldType) -> String {

        switch type {

        case .oldPass:
            return LocalizationKeys.TextField.InlineError.passwordInvalid.localize()

        case .pass:

            let oldPassword = textFields.first(where: { $0.type == .oldPass })?.text
            let newPassword = textFields.first(where: { $0.type == .pass })?.text

            if oldPassword == newPassword {
                return LocalizationKeys.TextField.InlineError.passwordMustBeDifferent.localize()
            }

            return LocalizationKeys.TextField.InlineError.passwordInvalidLong.localize()

        case .confirmPass:
            return LocalizationKeys.TextField.InlineError.passwordMismatch.localize()
        }
    }

    @MainActor
    func performChangePassword() {

        guard validateAllFields() else { return }
        primaryButton.isLoading = true

        Task { [weak self] in
            guard let self else { return }
            
            let currentPassword = textFields.first(where: { $0.type == .oldPass })?.text ?? ""
            let newPassword = textFields.first(where: { $0.type == .confirmPass })?.text ?? ""

            let result = await ChangePasswordUserUseCase().execute(input: ChangePasswordUserUseCaseInput(currentPassword: currentPassword, newPassword: newPassword))

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
