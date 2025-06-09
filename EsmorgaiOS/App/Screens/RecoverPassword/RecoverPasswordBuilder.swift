//
//  RecoverPasswordBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 3/6/25.
//

import Foundation

class RecoverPasswordBuilder {

    func build(coordinator:( any CoordinatorProtocol)? = nil) -> RecoverPasswordView {
        let viewModel = RecoverPasswordViewModel(coordinator: coordinator)
        return RecoverPasswordView(viewModel: viewModel)
    }

}
