//
//  SaveEventAttendeesUseCase.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 08/09/2026.
//

import Foundation

struct SaveEventAttendeesUseCaseInput {
    let eventId: String
    let attendees: [EventAttendee]
}

typealias SaveEventAttendeesUseCaseResult = Result<Void, Error>
typealias SaveEventAttendeesUseCaseAlias = BaseUseCase<SaveEventAttendeesUseCaseInput, SaveEventAttendeesUseCaseResult>

class SaveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: SaveEventAttendeesUseCaseInput) async -> SaveEventAttendeesUseCaseResult {
        do {
            try await eventsRepository.saveAttendees(input.attendees, for: input.eventId)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
}
