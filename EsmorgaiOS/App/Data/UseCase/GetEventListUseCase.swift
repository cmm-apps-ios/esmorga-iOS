//
//  GetEventListUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

typealias GetEventListResult = Result<[EventModels.Event], Error>

protocol GetEventListUseCaseProtocol {
    func getEventList() async -> GetEventListResult
}

class GetEventListUseCase: GetEventListUseCaseProtocol {

    private var eventsRepsitory: EventsRepositoryProtocol

    init(eventsRepsitory: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepsitory = eventsRepsitory
    }

    func getEventList() async -> GetEventListResult {
        do {
            let events = try await eventsRepsitory.getEventList()
            return .success(events)
        } catch let error {
            return .failure(error)
        }
    }
}
