//
//  RegistrationBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import Foundation

class RegistrationBuilder {

    func build(coordinator: any CoordinatorProtocol) -> RegistrationView {
        let viewModel = RegistrationViewModel(coordinator: coordinator)
        return RegistrationView(viewModel: viewModel)
    }
}
