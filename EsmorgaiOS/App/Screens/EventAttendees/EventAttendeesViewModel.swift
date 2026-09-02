//
//  EventAttendeesViewModel.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

import Foundation
import SwiftUI

enum EventAttendeesViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
    case empty
}

class EventAttendeesViewModel: BaseViewModel<EventAttendeesViewStates> {
    
    private let getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias
    private let eventId: String
    @Published var attendeesNames: [String] = []
    
    init(coordinator: (any CoordinatorProtocol)?,
         getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias = GetEventAttendeesUseCase(),
         eventId: String) {
        self.getEventAttendeesUseCase = getEventAttendeesUseCase
        self.eventId = eventId
        super.init(coordinator: coordinator)
    }
    
    @MainActor
    func getEventAttendees() async {
        let result = await getEventAttendeesUseCase.execute(input: eventId)
        
        await MainActor.run {
            switch result {
            case .success(let attendees):
                attendeesNames = attendees.map(\.name)
            case .failure(let error):
                //TODO: ask what happens if there is an error from backend
                attendeesNames = []
            }
        }
    }
}
