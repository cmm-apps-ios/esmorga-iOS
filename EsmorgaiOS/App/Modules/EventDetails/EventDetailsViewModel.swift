//
//  EventDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/8/24.
//

import Foundation

enum EventDetailsViewStates: ViewStateProtocol {
    case ready
}

class EventDetailsViewModel: BaseViewModel<EventDetailsViewStates> {

    private let router: EventDetailsRouterProtocol
    private let navigationManager: NavigationManagerProtocol

    @Published var showMethodsAlert: Bool = false
    var navigationMethods = [NavigationModels.Method]()

    init(router: EventDetailsRouterProtocol,
         navigationManager: NavigationManagerProtocol = NavigationManager()) {
        self.router = router
        self.navigationManager = navigationManager
    }

    func openLocation(latitude: Double?, longitude: Double?) {

        guard let latitude, let longitude else { return }
        navigationMethods = navigationManager.getMethods(latitude: latitude, longitude: longitude)
        if navigationMethods.count == 1, let method = navigationMethods.first {
            router.openNavigationApp(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        router.openNavigationApp(method)
    }
}
