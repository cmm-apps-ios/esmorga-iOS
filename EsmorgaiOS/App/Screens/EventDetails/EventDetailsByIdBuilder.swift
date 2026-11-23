//
//  EventDetailsByIdBuilder.swift
//  EsmorgaiOS
//

import Foundation

class EventDetailsByIdBuilder {

    func build(coordinator: any CoordinatorProtocol, eventId: String) -> EventDetailsByIdView {
        let viewModel = EventDetailsByIdViewModel(coordinator: coordinator, eventId: eventId)
        return EventDetailsByIdView(viewModel: viewModel)
    }
}
