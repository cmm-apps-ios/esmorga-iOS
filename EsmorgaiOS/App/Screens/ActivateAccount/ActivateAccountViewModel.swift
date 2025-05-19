//
//  ActivateAccountViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

enum ActivateAccountViewStates: ViewStateProtocol {
    case ready
}

class ActivateAccountViewModel: BaseViewModel<ActivateAccountViewStates> {

    @Published var primaryButton = LoginModels.Button(title: "Continuar",
                                                      isLoading: false)
}
