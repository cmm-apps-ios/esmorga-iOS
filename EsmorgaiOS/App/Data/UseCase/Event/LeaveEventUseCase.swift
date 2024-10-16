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

    private var eventsRepsitory: EventsRepositoryProtocol

    init(eventsRepsitory: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepsitory = eventsRepsitory
    }

    override func job(input: String) async -> LeaveEventUseCaseResult {
        do {
            try await eventsRepsitory.leaveEvent(id: input)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
