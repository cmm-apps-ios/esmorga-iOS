//
//  EventListViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import Foundation

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

    init(coordinator: (any CoordinatorProtocol)?,
         getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase()) {
        self.getEventListUseCase = getEventListUseCase
        super.init(coordinator: coordinator)
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
