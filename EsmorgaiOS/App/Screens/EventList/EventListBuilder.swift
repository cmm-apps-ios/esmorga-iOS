//
//  EventListBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class EventListBuilder {

    func build(coordinator:( any CoordinatorProtocol)? = nil) -> EventListView {
        let viewModel = EventListViewModel(coordinator: coordinator)
        return EventListView(viewModel: viewModel)
    }
}
