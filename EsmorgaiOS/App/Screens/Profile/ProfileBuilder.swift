//
//  ProfileBuilder.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

class ProfileBuilder {
    
    func build(coordinator:( any CoordinatorProtocol)? = nil) -> ProfileView {
        let viewModel = ProfileViewModel(coordinator: coordinator)
        return ProfileView(viewModel: viewModel)
    }
}
