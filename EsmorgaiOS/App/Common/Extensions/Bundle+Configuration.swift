//
//  Bundle+Configuration.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/9/24.
//

import Foundation

extension Bundle {

    static var identifier: String { Bundle.main.bundleIdentifier ?? "no.bundle" }

    private static var customConfigurations: [String: String]? {
        Bundle.main.object(forInfoDictionaryKey: "CustomConfigurations") as? [String: String]
    }

    static var baseURL: String {
        guard let dictionary = customConfigurations,
        let url = dictionary["kBaseURL"] else { return "missing.base.url" }
        return url
    }

    /// OneSignal App ID provided by the active xcconfig (QA/PROD). Returns nil
    /// when the key is absent or the xcconfig variable was left empty.
    static var oneSignalAppID: String? {
        guard let value = customConfigurations?["kOneSignalAppID"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty,
              !value.contains("$(") else { return nil }
        return value
    }

    /// Deployment environment tag (matches backend APP_ENV, e.g. "qa"/"prod").
    static var appEnvironment: String? {
        guard let value = customConfigurations?["kAppEnvironment"]?
            .trimmingCharacters(in: .whitespacesAndNewlines),
              !value.isEmpty,
              !value.contains("$(") else { return nil }
        return value
    }

    /// Marketing version (CFBundleShortVersionString) used for OneSignal tags.
    static var shortVersion: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "unknown"
    }
}
