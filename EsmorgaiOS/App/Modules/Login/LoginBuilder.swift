//
//  LoginBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Foundation

class LoginBuilder {

    func build(mainRouter: Router<MainRoute>) -> LoginView {
        let router = LoginRouter(router: mainRouter)
        let viewModel = LoginViewModel(router: router)
        return LoginView(viewModel: viewModel)
    }
}
