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
    case activate(code: String)
    case confirmRegister(email: String)
    case dialog(ErrorDialog.Model)
    case eventList
    case eventDetails(EventModels.Event)
    case dashboard

    public var id: Self { self }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
