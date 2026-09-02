//
//  RemoteEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

protocol RemoteEventsDataSourceProtocol {
    func fetchEvents() async throws -> [RemoteEventListModel.Event]
    func fetchEventAttendees(eventId: String) async throws -> [RemoteEventAttendee]
}

class RemoteEventsDataSource: RemoteEventsDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func fetchEvents() async throws -> [RemoteEventListModel.Event] {
        do {
            let eventList: RemoteEventListModel.EventList = try await networkRequest.request(networkService: EventsNetworkService.eventsList)
            return eventList.events
        } catch let error {
            throw error
        }
    }
    
    func fetchEventAttendees(eventId: String) async throws -> [RemoteEventAttendee] {
        do {
            let eventAttendees: [RemoteEventAttendee] = try await networkRequest.request(networkService: EventsNetworkService.eventAttendees(eventId: eventId))
            return eventAttendees
        } catch let error {
            throw error
        }
    }
}
