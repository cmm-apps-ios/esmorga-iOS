//
//  LoginBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

class LoginBuilder {

    func build(coordinator: any CoordinatorProtocol) -> LoginView {
        let viewModel = LoginViewModel(coordinator: coordinator)
        return LoginView(viewModel: viewModel)
    }
}
