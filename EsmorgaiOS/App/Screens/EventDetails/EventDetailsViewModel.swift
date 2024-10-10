//
//  EventDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/8/24.
//

import Foundation

enum EventDetailsViewState: ViewStateProtocol {
    case ready
    case loaded(isLogged: Bool)
}

class EventDetailsViewModel: BaseViewModel<EventDetailsViewState> {

    private let navigationManager: NavigationManagerProtocol
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    private let event: EventModels.Event

    @Published var showMethodsAlert: Bool = false
    @Published var model: EventDetails.Model = .empty
    var navigationMethods = [NavigationModels.Method]()

    init(coordinator: (any CoordinatorProtocol)?,
         event: EventModels.Event,
         navigationManager: NavigationManagerProtocol = NavigationManager(),
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        self.navigationManager = navigationManager
        self.event = event
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator)
    }

    @MainActor
    func viewLoad() async {
        let isUserLogged = await getLocalUserUseCase.execute().isSuccess
        model = EventDetailsMapper.mapEventDetails(event, isUserLogged: isUserLogged)
        changeState(.loaded(isLogged: isUserLogged))
    }

    func openLocation() {

        guard let latitude = event.latitude, let longitude = event.longitude else { return }
        navigationMethods = navigationManager.getMethods(latitude: latitude, longitude: longitude)
        if navigationMethods.count == 1, let method = navigationMethods.first {
            openNavigationMethod(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        coordinator?.openNavigationApp(method)
    }

    func primaryButtonTapped() {
        switch state {
        case .loaded(let isLogged):
            guard isLogged else {
                coordinator?.push(destination: .login)
                return
            }
            event.isUserJoined ? leaveEvent() : joinEvent()
        case .ready: break
        }
    }

    private func leaveEvent() {
        //TODO: future US
        self.snackBar = .init(message: "Leave Event Tapped",
                              isShown: true)
    }

    private func joinEvent() {
        //TODO: future US
        self.snackBar = .init(message: "Join Event Tapped",
                              isShown: true)
    }
}
