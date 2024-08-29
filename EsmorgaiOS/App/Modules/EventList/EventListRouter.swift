//
//  EventListRouter.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

protocol EventListRouterProtocol {
    func navigateToDetails(event: EventModels.Event)
}

class EventListRouter<T: Routable>: EventListRouterProtocol {

    private let router: Router<T>

    init(router: Router<T>) {
        self.router = router
    }

    func navigateToDetails(event: EventModels.Event) {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.details(event))
        default:
            print("Error")
        }
    }
}
