//
//  GetEventAttendeesUseCase.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

import Foundation

typealias GetEventAttendeesUseCaseResult = Result<[EventAttendee], Error>
typealias GetEventAttendeesUseCaseAlias = BaseUseCase<String, GetEventAttendeesUseCaseResult>

class GetEventAttendeesUseCase: GetEventAttendeesUseCaseAlias {

    private var eventsRepository: EventsRepositoryProtocol

    init(eventsRepository: EventsRepositoryProtocol = EventsRepository()) {
        self.eventsRepository = eventsRepository
    }

    override func job(input: String) async -> GetEventAttendeesUseCaseResult {
        do {
            let attendees = try await eventsRepository.getEventAttendees(id: input)
            return .success((attendees))
        } catch {
            return .failure(error)
        }
    }
}
