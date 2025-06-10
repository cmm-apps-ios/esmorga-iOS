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
}
