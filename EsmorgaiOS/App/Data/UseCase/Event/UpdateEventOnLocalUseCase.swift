//
//  UpdateEventOnLocalUseCase.swift
//  EsmorgaiOS
//
//  Created by Moran, Marcelo on 06/10/26.
//

import Foundation

typealias UpdateEventOnLocalUseCaseResult = Result<Void, Error>
typealias UpdateEventOnLocalUseCaseAlias = BaseUseCase<EventModels.Event, UpdateEventOnLocalUseCaseResult>

class UpdateEventOnLocalUseCase: UpdateEventOnLocalUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: EventModels.Event) async -> UpdateEventOnLocalUseCaseResult {
        do {
            try await eventsRepository.updateEventOnLocal(event: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
