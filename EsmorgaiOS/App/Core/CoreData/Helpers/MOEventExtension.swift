//
//  MOEventExtension.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 06/10/2026.
//

extension MOEvent {

    func update(from event: EventModels.Event) {
        eventId = event.eventId
        name = event.name
        date = event.date
        details = event.details
        eventType = event.eventType
        imageURL = event.imageURL
        latitude = event.latitude ?? 0
        longitude = event.longitude ?? 0
        location = event.location
        creationDate = event.creationDate
        isUserJoined = event.isUserJoined
        joinDeadline = event.joinDeadline
        currentAttendeeCount = Int32(event.currentAttendeeCount)
        maxCapacity = Int32(event.maxCapacity)
    }
}
