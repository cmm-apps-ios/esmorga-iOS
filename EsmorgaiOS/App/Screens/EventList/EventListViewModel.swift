//
//  EventListViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import Foundation
import FirebaseCrashlytics

enum EventListViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
    case empty
}

class EventListViewModel: BaseViewModel<EventListViewStates> {

    @Published var errorModel = EventListModels.ErrorModel(imageName: "AlertEsmorga",
                                                           title: LocalizationKeys.DefaultError.title.localize(),
                                                           subtitle: LocalizationKeys.DefaultError.body.localize(),
                                                           buttonText: LocalizationKeys.Buttons.retry.localize())
    @Published var events: [EventModels.Event] = []
    private let getEventListUseCase: GetEventListUseCaseAlias
    private let updateEventOnLocalUseCase: UpdateEventOnLocalUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?,
         getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase(),
         updateEventOnLocalUseCase: UpdateEventOnLocalUseCaseAlias = UpdateEventOnLocalUseCase()) {
        self.getEventListUseCase = getEventListUseCase
        self.updateEventOnLocalUseCase = updateEventOnLocalUseCase
        super.init(coordinator: coordinator)
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleEventUpdated(notification:)),
            name: .eventUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc
    private func handleEventUpdated(notification: Notification) {
        guard let updatedEvent = notification.userInfo?["event"] as? EventModels.Event,
              let index = events.firstIndex(where: { $0.id == updatedEvent.id }) else {
            return
        }
        events[index] = updatedEvent
        
        Task {
            _ = await updateEventOnLocalUseCase.execute(input: updatedEvent)
        }
    }

    func eventTapped(_ event: EventModels.Event) {
        coordinator?.push(destination: .eventDetails(event))
    }

    @MainActor
    func getEventList(forceRefresh: Bool) async {

        if self.state == .ready || forceRefresh {
            changeState(.loading)
        }

        let result = await getEventListUseCase.execute(input: forceRefresh)

        switch result {
        case .success(let events):
            self.events = events.data
            if events.data.isEmpty {
                self.changeState(.empty)
            } else {
                self.changeState(.loaded)
            }

            if events.error {
                self.snackBar = .init(message: LocalizationKeys.Snackbar.noInternet.localize(),
                                      isShown: true)
                self.reportErrorToCrashlytics()
            }
        case .failure:
            self.changeState(.error)
        }
    }
}

enum EventListModels {

    struct ErrorModel {
        let imageName: String
        var title: String
        var subtitle: String
        var buttonText: String
    }
}
