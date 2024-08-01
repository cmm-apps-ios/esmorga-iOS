//
//  EventListViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import Foundation

class EventListViewModel: ObservableObject {

    @Published var isLoading: Bool = false
    @Published var events: [EventModels.Event] = []
    @Published var hasError: Bool = false
    @Published var showSnackbar: Bool = false

    private var getEventListUseCase: GetEventListUseCaseProtocol
    init(getEventListUseCase: GetEventListUseCaseProtocol = GetEventListUseCase()) {
        self.getEventListUseCase = getEventListUseCase
    }

    func getEventList(forceRefresh: Bool) {

        hasError = false
        isLoading = true

        Task { [weak self] in
            guard let self else { return }

            let result = await getEventListUseCase.getEventList(forceRefresh: forceRefresh)

            await MainActor.run {
                self.isLoading = false

                switch result {
                case .success(let events):
                    self.events = events.data
                    if events.error {
                        self.showSnackbar = true
                    }
                case .failure:
                    self.hasError = true
                }
            }
        }
    }
}
