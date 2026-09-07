//
//  SaveEventAttendeesUseCase.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 08/09/2026.
//

import Foundation

typealias SaveEventAttendeesUseCaseResult = Result<[EventAttendee], Error>
typealias SaveEventAttendeesUseCaseAlias = BaseUseCase<String, SaveEventAttendeesUseCaseResult>

class SaveEventAttendeesUseCase: SaveEventAttendeesUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: String) async -> SaveEventAttendeesUseCaseResult {
        do {
            let attendees = try await eventsRepository.getEventAttendees(id: input)
            return .success((attendees))
        } catch {
            return .failure(error)
        }
    }
}
