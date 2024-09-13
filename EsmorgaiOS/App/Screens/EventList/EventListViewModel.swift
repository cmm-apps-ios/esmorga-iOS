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

    private let getEventListUseCase: GetEventListUseCaseAlias
    var events: [EventModels.Event] = []

    init(coordinator: (any CoordinatorProtocol)?,
         getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase()) {
        self.getEventListUseCase = getEventListUseCase
        super.init(coordinator: coordinator)
    }

    func eventTapped(_ event: EventModels.Event) {
        coordinator?.push(destination: .eventDetails(event))
    }

    func getEventList(forceRefresh: Bool) {

        changeState(.loading)

        Task { [weak self] in
            guard let self else { return }

            let result = await getEventListUseCase.execute(input: forceRefresh)

            await MainActor.run {

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
    }
}
