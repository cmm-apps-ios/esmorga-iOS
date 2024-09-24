//
//  EventBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 24/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class EventBuilder {

    private var eventId: String = "1234"
    private var name: String = "Event Name"
    private var date: Date = Date(timeIntervalSince1970: 10000)
    private var details: String = "Event Details"
    private var eventType: String = "ONLINE"
    private var imageURL: URL?
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var location: String = "A Coruña"
    private var creationDate: Date = Date(timeIntervalSince1970: 10000)
    private var isUserJoined: Bool = false

    func with(eventId: String) -> Self {
        self.eventId = eventId
        return self
    }

    func with(name: String) -> Self {
        self.name = name
        return self
    }

    func with(date: Date) -> Self {
        self.date = date
        return self
    }

    func with(details: String) -> Self {
        self.details = details
        return self
    }

    func with(eventType: String) -> Self {
        self.eventType = eventType
        return self
    }

    func with(imageURL: URL) -> Self {
        self.imageURL = imageURL
        return self
    }

    func with(latitude: Double) -> Self {
        self.latitude = latitude
        return self
    }

    func with(longitude: Double) -> Self {
        self.longitude = longitude
        return self
    }

    func with(location: String) -> Self {
        self.location = location
        return self
    }

    func with(creationDate: Date) -> Self {
        self.creationDate = creationDate
        return self
    }

    func with(isUserJoined: Bool) -> Self {
        self.isUserJoined = isUserJoined
        return self
    }

    func build() -> EventModels.Event {
        return EventModels.Event(eventId: eventId,
                                 name: name,
                                 date: date,
                                 details: details,
                                 eventType: eventType,
                                 imageURL: imageURL,
                                 latitude: latitude,
                                 longitude: longitude,
                                 location: location,
                                 creationDate: creationDate,
                                 isUserJoined: isUserJoined)
    }
}
