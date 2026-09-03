//
//  ChangePasswordBuilder.swift
//  EsmorgaiOS
//
//  Created by Moran, Marcelo on 27/8/26.
//

import Foundation

class ChangePasswordBuilder {

    func build(coordinator: any CoordinatorProtocol) -> ChangePasswordView {
        let viewModel = ChangePasswordViewModel(coordinator: coordinator)
        return ChangePasswordView(viewModel: viewModel)
    }
 
}
