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

    func openAppleMaps(latitude: Double?, longitude: Double?) {

        guard let latitude, let longitude else { return }
        guard let url = URL(string: "maps://?saddr=&daddr=\(latitude),\(longitude)") else { return }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
