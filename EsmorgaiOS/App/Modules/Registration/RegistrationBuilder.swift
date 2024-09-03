//
//  RegistrationBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import Foundation

class RegistrationBuilder {

    func build(mainRouter: Router<MainRoute>) -> RegistrationView {
        let router = RegistrationRouter(router: mainRouter)
        let viewModel = RegistrationViewModel(router: router)
        return RegistrationView(viewModel: viewModel)
    }
}
