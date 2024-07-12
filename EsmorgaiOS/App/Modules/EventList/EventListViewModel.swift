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
    @Published var showSnackBar: Bool = false

    var errorButtonAction: (() -> Void)?

    private var getEventListUseCase: GetEventListUseCaseProtocol
    init(getEventListUseCase: GetEventListUseCaseProtocol = GetEventListUseCase()) {
        self.getEventListUseCase = getEventListUseCase
    }


    @MainActor func getEventList() async {

        hasError = false
        isLoading = true

        let result = await getEventListUseCase.getEventList()
        self.isLoading = false

        switch result {
        case .success(let events):
            self.events = events
        case .failure:
            self.hasError = true
        }
    }
}
