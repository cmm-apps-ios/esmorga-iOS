//
//  AccountSession.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 16/9/24.
//

import Foundation

struct AccountSession: Equatable, Encodable, Decodable, KeychainCodable {

    let accessToken: String
    let refreshToken: String
    let expirationDate: Date

    init(accessToken: String, refreshToken: String, ttl: Double) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        expirationDate = Date(timeIntervalSinceNow: ttl)
    }

    private enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case expirationDate
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        accessToken = try values.decode(String.self, forKey: .accessToken)
        refreshToken = try values.decode(String.self, forKey: .refreshToken)
        expirationDate = try values.decode(Date.self, forKey: .expirationDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(accessToken, forKey: .accessToken)
        try container.encode(refreshToken, forKey: .refreshToken)
        try container.encode(expirationDate.timeIntervalSince1970, forKey: .expirationDate)
    }

    static var service: String { "\(Bundle.identifier)"}
    static var account: String { "AccountSession"}
}
