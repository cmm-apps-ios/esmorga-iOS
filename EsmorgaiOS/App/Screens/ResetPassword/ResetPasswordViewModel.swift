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

    @Published var textFields = [ResetPasswordModels.TextFieldModels]()

    @Published var primaryButton = RecoverPasswordModels.Button(title:"Cambiar constraseña",
                                                                isLoading: false)

    var isFormValid: Bool {
        textFields.allSatisfy { tf in //true si cumple
            !tf.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && tf.errorMessage == nil
        }
        && (
            textFields.first(where: { $0.type == .pass })?.text ==
            textFields.first(where: { $0.type == .confirmPass })?.text
        )
    }

    init(coordinator: (any CoordinatorProtocol)?, code: String) {

        print("Código recibido al viewModel: \(code)")

        super.init(coordinator: coordinator)

        textFields =  [ResetPasswordModels.TextFieldModels(type: .pass,
                                                           text: "",
                                                           title: "Nueva Contraseña",
                                                           placeholder: "Introduce la nueva contraseña",
                                                           isProtected: true),
                       ResetPasswordModels.TextFieldModels(type: .confirmPass,
                                                           text: "",
                                                           title: "Repetir Contraseña",
                                                           placeholder: "Confirma tu contraseña",
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
        case .pass: return LocalizationKeys.TextField.InlineError.password.localize()
        case .confirmPass: return LocalizationKeys.TextField.InlineError.passwordMismatch.localize()
        }
    }

    func performResetPassword() {
        //
        print("reset")
    }
}
