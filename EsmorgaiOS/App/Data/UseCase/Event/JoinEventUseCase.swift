//
//  JoinEventUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 11/10/24.
//

import Foundation

typealias JoinEventUseCaseResult = Result<Void, Error>
typealias JoinEventUseCaseAlias = BaseUseCase<String, JoinEventUseCaseResult>

class JoinEventUseCase: JoinEventUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: String) async -> JoinEventUseCaseResult {
        do {
            try await eventsRepository.joinEvent(id: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
