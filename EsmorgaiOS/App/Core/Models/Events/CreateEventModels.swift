//
//  CreateEventModels.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import Foundation

/// Domain representation of the event categories supported by the backend.
enum EventType: String, CaseIterable, Identifiable {
    case party
    case sport
    case food
    case charity
    case games

    var id: String { rawValue }

    /// Value expected by the API (capitalized).
    var apiValue: String {
        switch self {
        case .party: return "Party"
        case .sport: return "Sport"
        case .food: return "Food"
        case .charity: return "Charity"
        case .games: return "Games"
        }
    }

    var localizedName: String {
        switch self {
        case .party: return LocalizationKeys.CreateEvent.typeParty.localize()
        case .sport: return LocalizationKeys.CreateEvent.typeSport.localize()
        case .food: return LocalizationKeys.CreateEvent.typeFood.localize()
        case .charity: return LocalizationKeys.CreateEvent.typeCharity.localize()
        case .games: return LocalizationKeys.CreateEvent.typeGames.localize()
        }
    }
}

/// Parameters required to create a new event, produced by the create-event flow.
struct CreateEventParams {
    let eventName: String
    let eventDate: String
    let description: String
    let eventType: EventType
    let imageUrl: String?
    let locationName: String
    let locationLat: Double?
    let locationLong: Double?
    let maxCapacity: Int?
    let joinDeadline: String?
}
