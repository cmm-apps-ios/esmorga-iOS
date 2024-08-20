//
//  WelcomeRouter.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

protocol WelcomeScreenRouterProtocol {
    func navigateToLoggin()
    func navigateToEventList()
}

class WelcomeScreenRouter<T: Routable>: WelcomeScreenRouterProtocol {

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
