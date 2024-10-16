//
//  RemoteMyEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

protocol RemoteMyEventsDataSourceProtocol {
    func fetchEvents() async throws -> [RemoteEventListModel.Event]
    func joinEvent(id: String) async throws
    func leaveEvent(id: String) async throws
}

class RemoteMyEventsDataSource: RemoteMyEventsDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func fetchEvents() async throws -> [RemoteEventListModel.Event] {
        do {
            let eventList: RemoteEventListModel.EventList = try await networkRequest.request(networkService: AccountNetworkService.myEvents)
            return eventList.events
        } catch let error {
            throw error
        }
    }

    func joinEvent(id: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.join(eventId: id)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }

    func leaveEvent(id: String) async throws {
        do {
            _  = try await networkRequest.request(networkService: AccountNetworkService.leave(eventId: id)) as NetworkRequest.EmptyBodyObject
        } catch let error {
            throw error
        }
    }
}
