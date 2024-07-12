//
//  RemoteEventsDataSource.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

protocol RemoteEventsDataSourceProtocol {
    func fetchEvents() async throws -> [RemoteEventListModel.Event]?
}

class RemoteEventsDataSource: RemoteEventsDataSourceProtocol {

    private let networkRequest: NetworkRequestProtocol

    init(networkRequest: NetworkRequestProtocol = NetworkRequest()) {
        self.networkRequest = networkRequest
    }

    func fetchEvents() async throws -> [RemoteEventListModel.Event]? {
        do {
            let eventList: RemoteEventListModel.EventList = try await networkRequest.request(networkService: EventsNetworkService.eventsList)
            return eventList.events
        } catch let error {
            throw error
        }
    }
}
