//
//  WelcomeScreenViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import Foundation
import SwiftUI

enum WelcomeScreenViewStates: ViewStateProtocol {
    case ready
}

class WelcomeScreenViewModel: BaseViewModel<WelcomeScreenViewStates> {

    private let router: WelcomeRouterProtocol

    init(router: WelcomeRouterProtocol) {
        self.router = router
    }

    func loginButtonTapped() {
        router.navigateToLoggin()
    }

    func enterAsGuestTapped() {
        router.navigateToEventList()
    }
}

protocol WelcomeRouterProtocol {
    func navigateToLoggin()
    func navigateToEventList()
}

class WelcomeRouter<T: Routable>: WelcomeRouterProtocol {

    private let router: Router<T>

    init(router: Router<T>) {
        self.router = router
    }

    func navigateToLoggin() {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.login)
        default:
            print("Error")
        }
    }

    func navigateToEventList() {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.list)
        default:
            print("Error")
        }
    }
}

enum MainRoute: Routable {
    case login
    case list
    case details

    @ViewBuilder
    func viewToDisplay(router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            Text("Login")
        case .list:
            EventListView(viewModel: EventListViewModel(router: EventListRouter(router: router)))
        case .details:
            EventDetailsView(event: EventModels.Event(eventId: "12", name: "341234", date: .now, details: "sfasd", eventType: "asdf", imageURL: nil, latitude: nil, longitude: nil, location: "dfads", creationDate: .now))
        }
    }

    var navigationType: NavigationType {
        return .push
    }
}
