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
    
    @Published var attendees: [EventAttendee] = []
    @Published var showPaymentCheckBox: Bool = false
    
    private let getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias
    private let saveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    private let eventId: String
    private var user: UserModels.User?
    
    init(coordinator: (any CoordinatorProtocol)?,
         getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias = GetEventAttendeesUseCase(),
         saveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias = SaveEventAttendeesUseCase(),
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         eventId: String) {
        self.getEventAttendeesUseCase = getEventAttendeesUseCase
        self.saveEventAttendeesUseCase = saveEventAttendeesUseCase
        self.getLocalUserUseCase = getLocalUserUseCase
        self.eventId = eventId
        super.init(coordinator: coordinator)
    }
    
    @MainActor
    func viewLoad() async {
        user = try? await getLocalUserUseCase.execute().get()
        showPaymentCheckBox = user?.role == .admin
        await getEventAttendees()
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
