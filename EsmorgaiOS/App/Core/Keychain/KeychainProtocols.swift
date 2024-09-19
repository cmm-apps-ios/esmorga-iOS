//
//  KeychainProtocols.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation

public protocol KeychainCodable: Codable {
    static var accessGroup: String? { get }
    static var service: String { get }
    static var account: String { get }
}

public extension KeychainCodable {
    static var accessGroup: String? { nil }
    static func buildCodableKeychain() -> CodableKeychain<Self> {
        let keychain = Keychain(group: accessGroup, service: service, key: account)
        return CodableKeychain<Self>(keychain: keychain)
    }
}
