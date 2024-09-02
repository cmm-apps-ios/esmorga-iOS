//
//  RemoteEventListModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

class RemoteEventListModel {

    struct EventList: Codable {
        let events: [Event]
    }

    struct Event: Codable {
        let eventId: String
        let eventName: String
        let eventDate: String
        let description: String
        let eventType: String
        let imageUrl: String?
        let location: Location

        struct Location: Codable {
            let lat: Double?
            let long: Double?
            let name: String
        }

        func toDomain(creationDate: Date = Date.now) -> EventModels.Event {
            return EventModels.Event(eventId: eventId,
                                     name: eventName,
                                     date: eventDate.date(format: .iso8601) ?? Date(),
                                     details: description,
                                     eventType: eventType,
                                     imageURL: URL(string: imageUrl ?? ""),
                                     latitude: location.lat,
                                     longitude: location.long,
                                     location: location.name,
                                     creationDate: creationDate)
        }
    }
}
