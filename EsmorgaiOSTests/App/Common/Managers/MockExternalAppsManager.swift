//
//  MockNavigationManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockExternalAppsManager: ExternalAppsManagerProtocol {



    var methods: [NavigationModels.Method] = [NavigationModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

    func getMapMethods(latitude: Double, longitude: Double) -> [NavigationModels.Method] {
        return methods
    }


    func getMailMethods() -> [EsmorgaiOS.NavigationModels.Method] {
        return methods
    }

}
