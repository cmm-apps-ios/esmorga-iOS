//
//  CreateEventUseCase.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import Foundation

typealias CreateEventUseCaseResult = Result<Void, Error>
typealias CreateEventUseCaseAlias = BaseUseCase<CreateEventParams, CreateEventUseCaseResult>

class CreateEventUseCase: CreateEventUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: CreateEventParams) async -> CreateEventUseCaseResult {
        do {
            try await eventsRepository.createEvent(params: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
