//
//  MyEventsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import Foundation

enum MyEventsViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
    case empty
    case loggedOut
}

class MyEventsViewModel: BaseViewModel<MyEventsViewStates> {


    @Published var errorModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                          title: LocalizationKeys.DefaultError.title.localize(),
                                                          buttonText: LocalizationKeys.Buttons.retry.localize())
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                          title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                          buttonText: LocalizationKeys.Buttons.login.localize())

    private let getEventListUseCase: GetEventListUseCaseAlias
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    var events: [EventModels.Event] = []

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         getEventListUseCase: GetEventListUseCaseAlias = GetEventListUseCase(),
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        self.getEventListUseCase = getEventListUseCase
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator,
                   networkMonitor: networkMonitor)
    }

    func eventTapped(_ event: EventModels.Event) {
        coordinator?.push(destination: .eventDetails(event))
    }

    @MainActor
    func getEventList(forceRefresh: Bool) async {

        if self.state == .ready || forceRefresh {
            changeState(.loading)

        }

        let isUserLogged = await getLocalUserUseCase.execute()

        guard case .success = isUserLogged else {
            self.changeState(.loggedOut)
            return
        }

        let result = await getEventListUseCase.execute(input: forceRefresh)
        switch result {
        case .success(let events):
            self.events = events.data.filter { $0.isUserJoined }
            if self.events.isEmpty {
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

    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }

    func retryButtonTapped() async {
        await getEventList(forceRefresh: true)
    }
}
