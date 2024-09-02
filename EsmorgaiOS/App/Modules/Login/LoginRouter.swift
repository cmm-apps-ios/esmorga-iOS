//
//  LoginRouter.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 22/8/24.
//

import Foundation

protocol LoginRouterProtocol {
    func navigateToErrorDialog(model: ErrorDialog.Model)
    func navigateToList()
    func navigateToRegister()
}

class LoginRouter<T: Routable>: LoginRouterProtocol {

    private let router: Router<T>

    init(router: Router<T>) {
        self.router = router
    }

    func navigateToErrorDialog(model: ErrorDialog.Model) {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.dialog(model))
        default:
            print("Error")
        }
    }

    func navigateToList() {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.list)
        default:
            print("Error")
        }
    }

    func navigateToRegister() {
        switch router {
        case let mainRoute as Router<MainRoute>:
            mainRoute.routeTo(.register)
        default:
            print("Error")
        }
    }
}
