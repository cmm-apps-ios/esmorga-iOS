//
//  SplashBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import Foundation

class SplashBuilder {

    func build(coordinator: any CoordinatorProtocol) -> SplashView {
        let viewModel = SplashViewModel(coordinator: coordinator)
        return SplashView(viewModel: viewModel)
    }
}

