//
//  GetEventListUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

typealias GetEventListResult = Result<(data: [EventModels.Event], error: Bool), Error>

protocol GetEventListUseCaseProtocol {
    func getEventList(forceRefresh: Bool) async -> GetEventListResult
}

class GetEventListUseCase: GetEventListUseCaseProtocol {

    private var eventsRepsitory: EventsRepositoryProtocol

    init(eventsRepsitory: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepsitory = eventsRepsitory
    }

    func getEventList(forceRefresh: Bool) async -> GetEventListResult {
        do {
            let events = try await eventsRepsitory.getEventList(refresh: forceRefresh)
            return .success(events)
        } catch let error {
            return .failure(error)
        }
    }
}
