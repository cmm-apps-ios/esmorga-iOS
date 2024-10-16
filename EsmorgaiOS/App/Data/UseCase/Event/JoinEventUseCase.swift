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

    private var eventsRepsitory: EventsRepositoryProtocol

    init(eventsRepsitory: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepsitory = eventsRepsitory
    }

    override func job(input: String) async -> JoinEventUseCaseResult {
        do {
            try await eventsRepsitory.joinEvent(id: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
