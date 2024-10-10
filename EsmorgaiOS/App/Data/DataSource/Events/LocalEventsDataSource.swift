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
    func updateEvent(id: String, isUserJoined: Bool) async throws
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

    func updateEvent(id: String, isUserJoined: Bool) async throws {
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
}
