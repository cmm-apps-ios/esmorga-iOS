//
//  EventDetailsByIdViewModel.swift
//  EsmorgaiOS
//
//  Loading boundary for event details opened by `eventId` (push taps). Fetches
//  the freshest event for that id before the details screen is presented:
//  local cache first, then a forced refresh. Unknown/unavailable events fall
//  back to the notFound state instead of crashing.
//

import Foundation

enum EventDetailsByIdViewState: ViewStateProtocol {
    case ready
    case notFound
}

class EventDetailsByIdViewModel: BaseViewModel<EventDetailsByIdViewState> {

    private let eventId: String
    private let getEventListUseCase: GetEventListUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         eventId: String,
         getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase()) {
        self.eventId = eventId
        self.getEventListUseCase = getEventListUseCase
        super.init(coordinator: coordinator, networkMonitor: networkMonitor)
    }

    @MainActor
    func viewLoad() async {
        // Cache first (fast path), then force a refresh so a just-created event
        // that is not cached locally yet still resolves.
        if await resolve(usingCache: true) { return }
        if await resolve(usingCache: false) { return }
        changeState(.notFound)
    }

    /// Presents the resolved event by swapping this loading boundary out of the
    /// stack, or keeps it visible in its notFound state. A missing/inaccessible
    /// event or a load error ends in notFound; the user returns to the events
    /// screen with the back action below.
    @MainActor
    private func resolve(usingCache: Bool) async -> Bool {
        let result = await getEventListUseCase.execute(input: !usingCache)
        guard case .success(let events) = result,
              let event = events.data.first(where: { $0.eventId == eventId }) else {
            return false
        }
        if let coordinator = coordinator as? MainCoordinator {
            coordinator.replaceTop(with: .eventDetails(event))
        } else {
            coordinator?.push(destination: .eventDetails(event))
        }
        return true
    }

    func backToEventsTapped() {
        coordinator?.pop()
    }
}
