//
//  CodableKeychain.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation

open class CodableKeychain<T: Codable> {

    public let keychain: Keychain

    public init(keychain: Keychain) {
        self.keychain = keychain
    }

    open func store(codable: T) throws {
        let data = try JSONEncoder().encode(codable)
        try keychain.store(data: data)
    }

    open func fetch() throws -> T {
        let data = try keychain.fetch()
        return try JSONDecoder().decode(T.self, from: data)
    }

    open func delete() throws {
        try keychain.delete()
    }

    open func wipe() {
        try? keychain.delete()
    }
}


