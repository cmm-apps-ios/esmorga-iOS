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

    private let navigationManager: NavigationManagerProtocol

    @Published var showMethodsAlert: Bool = false
    var navigationMethods = [NavigationModels.Method]()

    init(coordinator: any CoordinatorProtocol,
         navigationManager: NavigationManagerProtocol = NavigationManager()) {
        self.navigationManager = navigationManager
        super.init(coordinator: coordinator)
    }

    func openLocation(latitude: Double?, longitude: Double?) {

        guard let latitude, let longitude else { return }
        navigationMethods = navigationManager.getMethods(latitude: latitude, longitude: longitude)
        if navigationMethods.count == 1, let method = navigationMethods.first {
            coordinator?.openNavigationApp(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        coordinator?.openNavigationApp(method)
    }
}
