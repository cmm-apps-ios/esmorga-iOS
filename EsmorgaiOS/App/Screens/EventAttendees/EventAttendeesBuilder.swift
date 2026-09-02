//
//  EventAttendeesBuilder.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

class EventAttendeesBuilder {

    func build(coordinator: any CoordinatorProtocol, eventId: String) -> EventAttendeesView {
        let viewModel = EventAttendeesViewModel(coordinator: coordinator, eventId: eventId)
        return EventAttendeesView(viewModel: viewModel)
    }
 
}
