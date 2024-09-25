//
//  EventModels.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/7/24.
//

import Foundation

enum EventModels {

    struct Event: Identifiable, DataConvertible, Equatable {

        var id: String { eventId }

        let eventId: String
        let name: String
        let date: Date
        let details: String
        let eventType: String
        let imageURL: URL?
        let latitude: Double?
        let longitude: Double?
        let location: String
        let creationDate: Date
        var isUserJoined: Bool

        typealias NSManagedObject = MOEvent

        @discardableResult
        func convert(to coreData: MOEvent) -> MOEvent? {
            let managedObject = coreData
            managedObject.eventId = eventId
            managedObject.name = name
            managedObject.date = date
            managedObject.details = details
            managedObject.eventType = eventType
            managedObject.imageURL = imageURL
            if let latitude {
                managedObject.latitude = latitude
            }
            if let longitude {
                managedObject.longitude = longitude
            }
            managedObject.location = location
            managedObject.creationDate = creationDate
            managedObject.isUserJoined = isUserJoined
            return managedObject
        }

        static func convert(from managedObject: MOEvent) -> EventModels.Event? {

            return EventModels.Event(eventId: managedObject.eventId!,
                                     name: managedObject.name!,
                                     date: managedObject.date!,
                                     details: managedObject.details!,
                                     eventType: managedObject.eventType!,
                                     imageURL: managedObject.imageURL,
                                     latitude: managedObject.latitude,
                                     longitude: managedObject.longitude,
                                     location: managedObject.location!,
                                     creationDate: managedObject.creationDate!,
                                     isUserJoined: managedObject.isUserJoined)
        }

        static func == (lhs: Event, rhs: Event) -> Bool {
            return lhs.eventId == rhs.eventId
            && lhs.name == rhs.name
            && lhs.date == rhs.date
            && lhs.details == rhs.details
            && lhs.eventType == rhs.eventType
            && lhs.imageURL == rhs.imageURL
            && lhs.latitude == rhs.latitude
            && lhs.longitude == rhs.longitude
            && lhs.isUserJoined == rhs.isUserJoined
        }
    }
}
