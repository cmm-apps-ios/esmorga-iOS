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
    private let saveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias
    private let eventId: String
    @Published var attendees: [EventAttendee] = []
    
    init(coordinator: (any CoordinatorProtocol)?,
         getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias = GetEventAttendeesUseCase(),
         saveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias = SaveEventAttendeesUseCase(),
         eventId: String) {
        self.getEventAttendeesUseCase = getEventAttendeesUseCase
        self.saveEventAttendeesUseCase = saveEventAttendeesUseCase
        self.eventId = eventId
        super.init(coordinator: coordinator)
    }
    
    @MainActor
    func getEventAttendees() async {
        let result = await getEventAttendeesUseCase.execute(input: eventId)
        
        await MainActor.run {
            switch result {
            case .success(let attendees):
                self.attendees = attendees
            case .failure(let error):
                //TODO: ask what happens if there is an error from backend
                attendees = []
            }
        }
    }
    
    @MainActor
    func updateAttendeeHasPayed() async {
        let inputSaveEventAttendeesUseCase: SaveEventAttendeesUseCaseInput = .init(
            eventId: self.eventId,
            attendees: self.attendees
        )
        _ = await saveEventAttendeesUseCase.execute(input: inputSaveEventAttendeesUseCase)
    }
}
