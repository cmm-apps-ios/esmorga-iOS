//
//  RegistrationConfirmBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/4/25.
//

import Foundation


class RegistrationConfirmBuilder {

    func build(coordinator: any CoordinatorProtocol, email: String) -> RegistrationConfirmView {
        let viewModel = RegistrationConfirmViewModel(coordinator: coordinator, email: email)
        return RegistrationConfirmView(viewModel: viewModel)
    }
}
