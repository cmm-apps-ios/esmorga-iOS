//
//  UserDefaults+Clear.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/3/25.
//

import Foundation
@testable import EsmorgaiOS

extension UserDefaults {

    func clear() {
        UserDefaults.clear()
    }

    static func clear() {
        UserDefaults.standard.removePersistentDomain(forName: Bundle.identifier)
        UserDefaults.standard.synchronize()
    }
}
