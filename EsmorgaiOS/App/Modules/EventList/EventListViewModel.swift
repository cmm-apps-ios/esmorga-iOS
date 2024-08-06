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

//    @Published var isLoading: Bool = false
    var events: [EventModels.Event] = []
    @Published var showSnackbar: Bool = false

    private var getEventListUseCase: GetEventListUseCaseAlias
    init(getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase()) {
        self.getEventListUseCase = getEventListUseCase
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
                        self.showSnackbar = true
                    }
                case .failure:
                    self.changeState(.error)
                }
            }
        }
    }
}
