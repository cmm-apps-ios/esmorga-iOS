//
//  ActivateAccountBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

class ActivateAccountBuilder {

    func build(coordinator: any CoordinatorProtocol) -> ActivateAccountView {
        let viewModel = ActivateAccountViewModel(coordinator: coordinator)
        return ActivateAccountView(viewModel: viewModel)
    }
}
