//
//  EventDetailsRouter.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation
import UIKit

protocol EventDetailsRouterProtocol {
    func openNavigationApp(_ method: NavigationModels.Method)
}

class EventDetailsRouter<T: Routable>: EventDetailsRouterProtocol {

    private let router: Router<T>

    init(router: Router<T>) {
        self.router = router
    }

    func openNavigationApp(_ method: NavigationModels.Method) {
        UIApplication.shared.open(method.url, options: [: ], completionHandler: nil)
    }
}
