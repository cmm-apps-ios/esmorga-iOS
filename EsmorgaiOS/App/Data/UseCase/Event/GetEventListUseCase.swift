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

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: Bool) async -> GetEventListResult {
        do {
            let events = try await eventsRepository.getEventList(refresh: input)
            return .success(events)
        } catch let error {
            return .failure(error)
        }
    }
}
