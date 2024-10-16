//
//  GetEventListUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation

typealias GetEventListResult = Result<(data: [EventModels.Event], error: Bool), Error>
typealias GetEventListUseCaseAlias = BaseUseCase<Bool, GetEventListResult>

class GetEventListUseCase: GetEventListUseCaseAlias {

    private var eventsRepsitory: EventsRepositoryProtocol

    init(eventsRepsitory: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepsitory = eventsRepsitory
    }

    override func job(input: Bool) async -> GetEventListResult {
        do {
            let events = try await eventsRepsitory.getEventList(refresh: input)
            return .success(events)
        } catch let error {
            return .failure(error)
        }
    }
}
