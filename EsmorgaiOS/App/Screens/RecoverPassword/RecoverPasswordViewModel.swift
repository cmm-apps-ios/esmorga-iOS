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
}
