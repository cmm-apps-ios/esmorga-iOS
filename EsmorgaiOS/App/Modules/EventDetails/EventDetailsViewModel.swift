//
//  EventDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/8/24.
//

import Foundation
import UIKit

enum EventDetailsViewStates: ViewStateProtocol {
    case ready
}

class EventDetailsViewModel: BaseViewModel<EventDetailsViewStates> {

    private let router: EventDetailsRouterProtocol

    init(router: EventDetailsRouterProtocol) {
        self.router = router
    }

    func openAppleMaps(latitude: Double?, longitude: Double?) {

        guard let latitude, let longitude else { return }
        router.openMaps(lat: latitude, long: longitude)
    }
}
