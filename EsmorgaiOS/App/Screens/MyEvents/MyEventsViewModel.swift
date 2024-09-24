//
//  MyEventsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import Foundation

enum MyEventsViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
    case empty
    case loggedOut
}

class MyEventsViewModel: BaseViewModel<MyEventsViewStates> {

    var events: [EventModels.Event] = []

    func eventTapped(_ event: EventModels.Event) {
        coordinator?.push(destination: .eventDetails(event))
    }

    func getEventList(forceRefresh: Bool) {
        changeState(.loading)
    }
}
