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
    private var remoteMyEventsDataSource: RemoteMyEventsDataSourceProtocol
    private var sessionKeychain: CodableKeychain<AccountSession>

    init(remoteDataSource: RemoteEventsDataSourceProtocol = RemoteEventsDataSource(),
         localEventsDataSource: LocalEventsDataSourceProtocol = LocalEventsDataSource(),
         remoteMyEventsDataSource: RemoteMyEventsDataSourceProtocol = RemoteMyEventsDataSource(),
         sessionKeychain: CodableKeychain<AccountSession> = AccountSession.buildCodableKeychain()) {
        self.remoteDataSource = remoteDataSource
        self.localEventsDataSource = localEventsDataSource
        self.remoteMyEventsDataSource = remoteMyEventsDataSource
        self.sessionKeychain = sessionKeychain
    }

    func getEventList(refresh: Bool) async throws -> ([EventModels.Event], Bool) {

        let storedEvents = await localEventsDataSource.getEvents()
        let shouldShowCache = CacheRule.shouldShowCache(date: storedEvents.first?.creationDate)

        guard !(!refresh && !storedEvents.isEmpty && shouldShowCache) else {
            return (storedEvents, false)
        }

        do {
            let events = try await getEventList()
            try await saveEvents(events)
            return (events, false)
        } catch NetworkError.noInternetConnection {
            return (storedEvents, true)
        } catch {
            throw error
        }
    }


    /// Method to request all the event available
    /// - Returns: List of EventModels.Event
    private func getAllEventList() async throws -> [EventModels.Event] {
        do {
            let events = try await remoteDataSource.fetchEvents()
            let domainEvents = events.compactMap { $0.toDomain() }
            return domainEvents
        } catch {
            throw error
        }
    }


    /// Method to request the list of events in which the user is joined
    /// - Returns: List of EventModels.Event
    private func getUserEvents() async throws -> [EventModels.Event] {
        do {
            let events = try await remoteMyEventsDataSource.fetchEvents()
            let domainEvents = events.compactMap { $0.toDomain() }
            return domainEvents
        } catch {
            throw error
        }
    }

    private func getEventList() async throws -> [EventModels.Event] {
        do {
            let allEvents = try await getAllEventList()
            if sessionKeychain.isLogged {
                let userEvents = try await getUserEvents()
                let combineEvents = combineEvents(allEvents: allEvents, userEvents: userEvents)
                return combineEvents
            } else {
                return allEvents
            }
        } catch {
            throw error
        }
    }


    /// Method to combine the full list of events available with the list of events in which the user is joinned. If event from user event list is present in the full list, event property "isUserJoined" is mark as true
    /// - Parameters:
    ///   - allEvents: List of all events available
    ///   - userEvents: List of events where the user is joined
    /// - Returns: List of EventModels.Event
    private func combineEvents(allEvents: [EventModels.Event], userEvents: [EventModels.Event]) -> [EventModels.Event] {
        let userEventIds = Set(userEvents.map { $0.id })
        return allEvents.compactMap { event in
            var updatedEvent = event
            updatedEvent.isUserJoined = userEventIds.contains(event.id)
            return updatedEvent
        }
    }

    private func saveEvents(_ events: [EventModels.Event]) async throws {
        try await localEventsDataSource.saveEvents(events)
    }
}
