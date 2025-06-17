//
//  RecoverPasswordBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/6/25.
//

import Foundation

class ResetPasswordBuilder {

    func build(coordinator: any CoordinatorProtocol, code: String) -> ResetPasswordView {
        let viewModel = ResetPasswordViewModel(coordinator: coordinator, code: code)
        return ResetPasswordView(viewModel: viewModel)
    }
 
}
