//
//  NavigationManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 5/9/24.
//

import Foundation
import UIKit

protocol NavigationManagerProtocol {
    func getMethods(latitude: Double, longitude: Double) -> [NavigationModels.Method]
}

class NavigationManager: NavigationManagerProtocol {

    func getMethods(latitude: Double, longitude: Double) -> [NavigationModels.Method] {
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
