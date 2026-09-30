//
//  RemoteEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

protocol RemoteEventsDataSourceProtocol {
    func fetchEvents() async throws -> [RemoteEventListModel.Event]
    func fetchEventAttendees(eventId: String) async throws -> RemoteEventAttendee
    func createEvent(params: CreateEventParams) async throws
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
    
    func fetchEventAttendees(eventId: String) async throws -> RemoteEventAttendee {
        do {
            let eventAttendees: RemoteEventAttendee = try await networkRequest.request(networkService: EventsNetworkService.eventAttendees(eventId: eventId))
            return eventAttendees
        } catch let error {
            throw error
        }
    }

    func createEvent(params: CreateEventParams) async throws {
        do {
            let body = CreateEventRequestModel(params: params).toData()
            _ = try await networkRequest.request(networkService: EventsNetworkService.createEvent(body: body)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }
}
