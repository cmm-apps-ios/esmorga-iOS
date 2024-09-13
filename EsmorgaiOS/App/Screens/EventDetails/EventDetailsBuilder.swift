//
//  EventDetailsBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class EventDetailsBuilder {

    func build(coordinator: any CoordinatorProtocol, event: EventModels.Event) -> EventDetailsView {
        let viewModel = EventDetailsViewModel(coordinator: coordinator)
        return EventDetailsView(viewModel: viewModel, event: event)
    }
}
