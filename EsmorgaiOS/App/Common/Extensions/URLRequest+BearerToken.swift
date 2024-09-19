//
//  URLRequest+BearerToken.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Foundation

public extension URLRequest {

    mutating func setBearerToken(_ token: String) {
        setValue("Bearer " + token, forHTTPHeaderField: "Authorization")
    }

    func getBearerToken() -> String? {
        headers["Authorization"]?.replacingOccurrences(of: "Bearer ", with: "")
    }
}
