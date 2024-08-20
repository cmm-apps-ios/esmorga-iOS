//
//  EventListBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class EventListBuilder {

    func build(mainRouter: Router<MainRoute>) -> EventListView {
        let router = EventListRouter(router: mainRouter)
        let viewModel = EventListViewModel(router: router)
        return EventListView(viewModel: viewModel)
    }
}
