//
//  MockNavigationManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockExternalAppsManager: ExternalAppsManagerProtocol {



    var methods: [DeepLinkModels.Method] = [DeepLinkModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

    var methods2: [DeepLinkModels.Method] = [DeepLinkModels.Method(title: "Gmail", url: URL(string: "googlegmail://co?to=&subject=Subject&body=Body")!)]

    func getMapMethods(latitude: Double, longitude: Double) -> [DeepLinkModels.Method] {
        return methods
    }


    func getMailMethods() -> [DeepLinkModels.Method] {
        return methods2
    }

}
