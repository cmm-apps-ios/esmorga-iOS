//
//  ActivateAccountBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

class ActivateAccountBuilder {

    func build(coordinator: any CoordinatorProtocol, code: String) -> ActivateAccountView {
        let viewModel = ActivateAccountViewModel(coordinator: coordinator, code: code)
        print("Construyendo builder...")
        return ActivateAccountView(viewModel: viewModel)
    }
}
