//
//  ErrorReport.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/4/25.
//

import FirebaseCrashlytics

class CrashEventManager {

    static let shared = CrashEventManager()

    private init() {}

    static func reportError() {
        // Keys
        Crashlytics.crashlytics().setCustomValue("offline", forKey: "Connection status")
        Crashlytics.crashlytics().setCustomValue("Loss of internet connection.", forKey: "Error Description")

        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "No internet connection"
        ]
        Crashlytics.crashlytics().record(error: NSError(domain: "com.esmorga", code: -1007, userInfo: userInfo))
    }
}
