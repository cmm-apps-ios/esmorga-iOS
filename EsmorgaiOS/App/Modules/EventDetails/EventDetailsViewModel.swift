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

    @Published var showMethodsAlert: Bool = false
    var navigationMethods = [NavigationModels.Method]()

    init(router: EventDetailsRouterProtocol) {
        self.router = router
    }

    func openAppleMaps(latitude: Double?, longitude: Double?) {

        guard let latitude, let longitude else { return }
        navigationMethods = getMethods(latitude: latitude, longitude: longitude)
        if navigationMethods.count == 1, let method = navigationMethods.first {
            router.openNavigationApp(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: NavigationModels.Method) {
        router.openNavigationApp(method)
    }

    private func getMethods(latitude: Double, longitude: Double) -> [NavigationModels.Method] {

        var methods = [NavigationModels.Method]()
        if let appleUrl = URL(string: "http://maps.apple.com/?saddr=&daddr=\(latitude),\(longitude)"),
           UIApplication.shared.canOpenURL(appleUrl) {
            let appleMaps = NavigationModels.Method(title: "Apple Maps", url: appleUrl)
            methods.append(appleMaps)
        }
        if let googleUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)"),
           UIApplication.shared.canOpenURL(googleUrl) {
            let googleMaps = NavigationModels.Method(title: "Google Maps", url: googleUrl)
            methods.append(googleMaps)
        }
        if let wazeSchemeUrl = URL(string: "waze://"),
           let wazeUrl = URL(string: "https://waze.com/ul?ll=\(latitude),\(longitude)&navigate=yes"),
           UIApplication.shared.canOpenURL(wazeSchemeUrl) {
            let waze = NavigationModels.Method(title: "Waze", url: wazeUrl)
            methods.append(waze)
        }
        return methods
    }
}

enum NavigationModels {
    

    struct Method {
        let title: String
        let url: URL
    }
}
