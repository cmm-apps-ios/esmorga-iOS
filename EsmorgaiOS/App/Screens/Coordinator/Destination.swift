//
//  Destination.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import Foundation

enum Destination: Hashable, Identifiable {
    case splash
    case welcome
    case login
    case register
    case confirmRegister(email: String)
    case activate(code: String)
    case recoverPassword
    case resetPassword(code: String)
    case changePassword
    case dialog(ErrorDialog.Model)
    case eventDetails(EventModels.Event)
    /// Loading boundary used by push taps: resolves the event by id (cache +
    /// refresh) before presenting the real details screen.
    case eventDetailsById(eventId: String)
    case eventAttendees(eventId: String)
    case pollDetails(Poll)
    case dashboard
    case createEvent
    case createEventType
    case createEventDate
    case createEventLocation
    case createEventImage

    public var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
