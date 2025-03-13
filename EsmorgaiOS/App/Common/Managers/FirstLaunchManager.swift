//
//  FirstLaunchManager.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/3/25.
//

import Foundation

final class FirstLaunchManager {

    private let userDefaults: UserDefaults

    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
    }

    /// Checks if the app is being launched for the first time. If so, it deletes the user session from the keychain to avoid use of old data from previous installations.
    func setFirstLaunch() {
        if !userDefaults.bool(forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue) {
            try? AccountSession.buildCodableKeychain().delete()
        }
        userDefaults.set(true, forKey: PreferencesKeys.General.firstTimeAppLaunch.rawValue)
        userDefaults.synchronize()
    }
}
