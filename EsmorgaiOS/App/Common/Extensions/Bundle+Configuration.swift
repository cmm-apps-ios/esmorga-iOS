//
//  Bundle+Configuration.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/9/24.
//

import Foundation

extension Bundle {

    static var identifier: String { Bundle.main.bundleIdentifier ?? "no.bundle" }
    static var baseURL: String {
        guard let dictionary = Bundle.main.object(forInfoDictionaryKey: "CustomConfigurations") as? [String: String],
        let url = dictionary["kBaseURL"] else { return "missing.base.url" }
        return url
    }
}
