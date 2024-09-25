//
//  MyEventsBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 24/9/24.
//

import Foundation

class MyEventsBuilder {

    func build(coordinator:( any CoordinatorProtocol)? = nil) -> MyEventsView {
        let viewModel = MyEventsViewModel(coordinator: coordinator)
        return MyEventsView(viewModel: viewModel)
    }
}
