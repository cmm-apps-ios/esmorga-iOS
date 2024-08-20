//
//  EventDetailsBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class EventDetailsBuilder {

    func build(mainRouter: Router<MainRoute>, event: EventModels.Event) -> EventDetailsView {
        let router = EventDetailsRouter(router: mainRouter)
        let viewModel = EventDetailsViewModel(router: router)
        return EventDetailsView(viewModel: viewModel, event: event)
    }
}


