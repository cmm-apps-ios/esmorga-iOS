//
//  NavigationManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 5/9/24.
//

import Foundation
import UIKit

protocol ExternalAppsManagerProtocol {
    func getMapMethods(latitude: Double, longitude: Double) -> [DeepLinkModels.Method]
    func getMailMethods() -> [DeepLinkModels.Method]
}

class ExternalAppsManager: ExternalAppsManagerProtocol {

    func getMapMethods(latitude: Double, longitude: Double) -> [DeepLinkModels.Method] {
        var methods = [DeepLinkModels.Method]()
        if let appleUrl = URL(string: "http://maps.apple.com/?saddr=&daddr=\(latitude),\(longitude)"),
           UIApplication.shared.canOpenURL(appleUrl) {
            let appleMaps = DeepLinkModels.Method(title: "Apple Maps", url: appleUrl)
            methods.append(appleMaps)
        }
        if let googleUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(latitude),\(longitude)"),
           UIApplication.shared.canOpenURL(googleUrl) {
            let googleMaps = DeepLinkModels.Method(title: "Google Maps", url: googleUrl)
            methods.append(googleMaps)
        }
        if let wazeSchemeUrl = URL(string: "waze://"),
           let wazeUrl = URL(string: "https://waze.com/ul?ll=\(latitude),\(longitude)&navigate=yes"),
           UIApplication.shared.canOpenURL(wazeSchemeUrl) {
            let waze = DeepLinkModels.Method(title: "Waze", url: wazeUrl)
            methods.append(waze)
        }
        return methods
    }

    func getMailMethods() -> [DeepLinkModels.Method] {
        var methods = [DeepLinkModels.Method]()

        if let gmailUrl = URL(string: "googlegmail://co?to=&subject=Subject&body=Body"),
           UIApplication.shared.canOpenURL(gmailUrl) {
            let gmail = DeepLinkModels.Method(title: "Gmail", url: gmailUrl)
            methods.append(gmail)
        }

        if let outlookUrl = URL(string: "ms-outlook://"),
           UIApplication.shared.canOpenURL(outlookUrl) {
            let outLookMail = DeepLinkModels.Method(title: "OutLookMail", url: outlookUrl)
            methods.append(outLookMail)
        }

        if let mailUrl = URL(string: "mailto:?subject=Subject&body=Body"),
           UIApplication.shared.canOpenURL(mailUrl) {
            let appleMail = DeepLinkModels.Method(title: "Apple Mail", url: mailUrl)
            methods.append(appleMail)
        }

        return methods
    }

}
