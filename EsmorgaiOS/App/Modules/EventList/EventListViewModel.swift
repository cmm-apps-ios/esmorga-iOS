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

    var events: [EventModels.Event] = []

    private let getEventListUseCase: GetEventListUseCaseAlias
    private let router: EventListRouterProtocol

    init(getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase(),
         router: EventListRouterProtocol) {
        self.getEventListUseCase = getEventListUseCase
        self.router = router
    }

    func eventTapped(_ event: EventModels.Event) {
        router.navigateToDetails(event: event)
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
