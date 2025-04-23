//
//  RegistrationConfirmViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/4/25.
//

import Foundation

enum RegsitrationConfirmViewStates: ViewStateProtocol {
    case ready
}

class RegistrationConfirmViewModel: BaseViewModel<RegistrationViewStates> {


    @Published var primaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.confirmEmail.localize(),
                                                      isLoading: false)
    @Published var secondaryButton = LoginModels.Button(title: LocalizationKeys.Buttons.resendEmail.localize(),
                                                        isLoading: false)

    func openMail() {


    }

    func resendMail() {


    }
}
