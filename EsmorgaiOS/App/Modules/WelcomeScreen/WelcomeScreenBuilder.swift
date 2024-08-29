//
//  WelcomeScreenBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class WelcomeScreenBuilder {

    func build(mainRouter: Router<MainRoute>) -> WelcomeScreenView {
        let router = WelcomeScreenRouter(router: mainRouter)
        let viewModel = WelcomeScreenViewModel(router: router)
        return WelcomeScreenView(viewModel: viewModel)
    }
}
