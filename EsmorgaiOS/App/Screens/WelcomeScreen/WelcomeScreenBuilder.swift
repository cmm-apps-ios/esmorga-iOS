//
//  WelcomeScreenBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class WelcomeScreenBuilder {

    func build(coordinator: (any CoordinatorProtocol)? = nil) -> WelcomeScreenView {
        let viewModel = WelcomeScreenViewModel(coordinator: coordinator)
        return WelcomeScreenView(viewModel: viewModel)
    }
}
