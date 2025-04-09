//
//  ErrorReport.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/4/25.
//

import FirebaseCrashlytics

class CrashlyticsErrorReport {
    static func handleNoInternetError() {
        let userInfo: [String: Any] = [
            NSLocalizedDescriptionKey: "No internet connection",
        ]
     //   Crashlytics.crashlytics().setCustomValue("No internet connection", forKey: "No internet connection")
        Crashlytics.crashlytics().record(error: NSError(domain: "com.esmorga.error", code: -1009, userInfo: userInfo))
    }
}
