//
//  DashboardBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import Foundation

class DashboardBuilder {

    func build(coordinator: (any CoordinatorProtocol)? = nil) -> DashboardView {
        let viewModel = DashboardViewModel(coordinator: coordinator)
        return DashboardView(viewModel: viewModel)
    }
}
