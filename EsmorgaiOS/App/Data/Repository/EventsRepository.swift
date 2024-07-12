//
//  EventsRepository.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

protocol EventsRepositoryProtocol {
    func getEventList() async throws -> [EventModels.Event]
}

class EventsRepository: EventsRepositoryProtocol {

    private var remoteDataSource: RemoteEventsDataSourceProtocol
    private var localEventsDataSource: LocalEventsDataSourceProtocol

    init(remoteDataSource: RemoteEventsDataSourceProtocol = RemoteEventsDataSource(),
         localEventsDataSource: LocalEventsDataSourceProtocol = LocalEventsDataSource()) {
        self.remoteDataSource = remoteDataSource
        self.localEventsDataSource = localEventsDataSource
    }

    func getEventList() async throws -> [EventModels.Event] {

        let storedEvents = await localEventsDataSource.getEvents()
        let shouldShowCache = CacheRule.shouldShowCache(date: storedEvents.first?.creationDate)

        if !storedEvents.isEmpty && shouldShowCache {
            return storedEvents
        }

        do {
            if let events = try await remoteDataSource.fetchEvents() {
                let mappedEvents = events.compactMap { $0.toDomain() }
                try await saveEvents(mappedEvents)
                return mappedEvents
            } else {
                return storedEvents
            }

        } catch let error {
            throw error
        }
    }

    private func saveEvents(_ events: [EventModels.Event]) async throws {
        try await localEventsDataSource.saveEvents(events)
    }
}
