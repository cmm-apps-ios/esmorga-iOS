//
//  KeychainBuilder.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation

public protocol KeychainBuilder {
    associatedtype Item: Codable
    static var accessGroup: String? { get }
    static var service: String { get }
    static var account: String { get }
}

public extension KeychainBuilder {
    static var accessGroup: String? { nil }
    static func build() -> CodableKeychain<Item> {
        let keychain = Keychain(group: accessGroup, service: service, key: account)
        return CodableKeychain<Item>(keychain: keychain)
    }
}
