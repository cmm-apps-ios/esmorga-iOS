//
//  EventsRepository.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

protocol EventsRepositoryProtocol {
    func getEventList(refresh: Bool) async throws -> ([EventModels.Event], Bool)
}

class EventsRepository: EventsRepositoryProtocol {

    private var remoteDataSource: RemoteEventsDataSourceProtocol
    private var localEventsDataSource: LocalEventsDataSourceProtocol

    init(remoteDataSource: RemoteEventsDataSourceProtocol = RemoteEventsDataSource(),
         localEventsDataSource: LocalEventsDataSourceProtocol = LocalEventsDataSource()) {
        self.remoteDataSource = remoteDataSource
        self.localEventsDataSource = localEventsDataSource
    }

    func getEventList(refresh: Bool) async throws -> ([EventModels.Event], Bool) {

        let storedEvents = await localEventsDataSource.getEvents()
        let shouldShowCache = CacheRule.shouldShowCache(date: storedEvents.first?.creationDate)

        guard !(!refresh && !storedEvents.isEmpty && shouldShowCache) else {
            return (storedEvents, false)
        }

        do {
            if let events = try await remoteDataSource.fetchEvents() {
                let mappedEvents = events.compactMap { $0.toDomain() }
                try await saveEvents(mappedEvents)
                return (mappedEvents, false)
            } else {
                return (storedEvents, false)
            }

        } catch NetworkError.noInternetConnection {
            return (storedEvents, true)
        } catch {
            throw error
        }
    }

    private func saveEvents(_ events: [EventModels.Event]) async throws {
        try await localEventsDataSource.saveEvents(events)
    }
}
