//
//  LeaveEventUseCase.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 16/10/24.
//

import Foundation

typealias LeaveEventUseCaseResult = Result<Void, Error>
typealias LeaveEventUseCaseAlias = BaseUseCase<String, JoinEventUseCaseResult>

class LeaveEventUseCase: LeaveEventUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: String) async -> LeaveEventUseCaseResult {
        do {
            try await eventsRepository.leaveEvent(id: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
