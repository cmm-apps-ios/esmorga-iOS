//
//  LocalEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/7/24.
//

import Foundation
import CoreData

protocol LocalEventsDataSourceProtocol {
    func getEvents() async -> [EventModels.Event]
    func saveEvents(_ events: [EventModels.Event]) async throws -> ()
    func updateIsUserJoinedEvent(id: String, isUserJoined: Bool) async throws
    func getAttendees(eventId: String) async throws -> [EventAttendee]
    func saveAttendees(_ attendees: [EventAttendee], for eventId: String) async throws
    func clearAll()
}

class LocalEventsDataSource: LocalEventsDataSourceProtocol {

    let container: NSPersistentContainer

    init(container: NSPersistentContainer = NSPersistentContainer(name: "Esmorga")) {
        self.container = container
        self.container.loadPersistentStores { description, error in
            if error != nil {
                fatalError("Cannot Load Core Data Model")
            }
        }
    }

    func getEvents() async -> [EventModels.Event] {
        let request = NSFetchRequest<MOEvent>(entityName: "MOEvent")
        do {
            let events = try container.viewContext.fetch(request)
            return events.compactMap { EventModels.Event.convert(from: $0) }
        } catch {
            return []
        }
    }
    
    func saveEvents(_ events: [EventModels.Event]) async throws -> () {
        clearAll()

        events.forEach { _ = $0.convert(in: container.viewContext) }
        try? container.viewContext.save()
        return ()
    }

    func updateIsUserJoinedEvent(id: String, isUserJoined: Bool) async throws {
        let request = NSFetchRequest<MOEvent>(entityName: "MOEvent")
        request.predicate = NSPredicate(format: "eventId == %@", id)

        do {
            if let moEvent = try container.viewContext.fetch(request).first {
                moEvent.isUserJoined = isUserJoined
                try container.viewContext.save()
            } else {
                throw NSError(domain: "LocalEventsDataSource", code: 404, userInfo: [NSLocalizedDescriptionKey: "Event not found"])
            }
        } catch {
            throw NSError(domain: "LocalEventsDataSource", code: 500, userInfo: [NSLocalizedDescriptionKey: "Failed to update event"])
        }
    }

    func clearAll() {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MOEvent")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: request)
        do {
            try container.viewContext.execute(deleteRequest)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Attendees
    
    func getAttendees(eventId: String) async throws -> [EventAttendee] {

        let request = NSFetchRequest<MOEvent>(
            entityName: "MOEvent"
        )

        request.predicate = NSPredicate(
            format: "eventId == %@",
            eventId
        )

        guard let event = try container.viewContext
            .fetch(request)
            .first
        else {
            return []
        }

        let attendees = event.attendees as? Set<MOEventAttendee> ?? []

        return attendees.map {
            EventAttendee(id: $0.id ?? UUID(),
                          name: $0.name ?? "",
                          hasPayed: $0.hasPayed)
        }
    }
    
    func saveAttendees(
        _ attendees: [EventAttendee],
        for eventId: String
    ) async throws {

        let context = container.viewContext

        let eventRequest = NSFetchRequest<MOEvent>(
            entityName: "MOEvent"
        )
        eventRequest.predicate = NSPredicate(
            format: "eventId == %@",
            eventId
        )

        guard let event = try context.fetch(eventRequest).first else {
            throw NSError(
                domain: "LocalEventsDataSource",
                code: 404,
                userInfo: [
                    NSLocalizedDescriptionKey: "Event not found"
                ]
            )
        }

        // Remove existing attendees for this event
        if let existingAttendees = event.attendees as? Set<MOEventAttendee> {
            existingAttendees.forEach {
                
                event.removeFromAttendees($0)
                context.delete($0)
            }
        }

        // Add new attendees
        attendees.forEach { attendee in

            let moAttendee = MOEventAttendee(context: context)
            moAttendee.id = attendee.id
            moAttendee.name = attendee.name
            moAttendee.hasPayed = attendee.hasPayed

            event.addToAttendees(moAttendee)
        }

        try context.save()
    }
    
}
