//
//  EventDetailsRouter.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation
import UIKit

protocol EventDetailsRouterProtocol {
    func openMaps(lat: Double, long: Double)
}

class EventDetailsRouter<T: Routable>: EventDetailsRouterProtocol {

    private let router: Router<T>

    init(router: Router<T>) {
        self.router = router
    }

    func openMaps(lat: Double, long: Double) {

        guard let url = URL(string: "maps://?saddr=&daddr=\(lat),\(long)") else { return }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
