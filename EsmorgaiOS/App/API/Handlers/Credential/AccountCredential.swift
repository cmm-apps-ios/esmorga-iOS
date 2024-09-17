//
//  AccountCredential.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Alamofire

struct AccountCredential: Credential {

    typealias Token = AccountSession
    private let accountSessionKeychain: CodableKeychain<AccountSession>

    init(accountSessionKeychain: CodableKeychain<AccountSession> = AccountSession.buildCodableKeychain()) {
        self.accountSessionKeychain = accountSessionKeychain
    }

    var accessToken: String? { try? accountSessionKeychain.fetch().accessToken }

    var refreshToken: String? { try? accountSessionKeychain.fetch().refreshToken }

    func store(tokens: AccountSession) throws { try accountSessionKeychain.store(codable: tokens) }

    var requiresRefresh: Bool {
        guard let expirationDate = try? accountSessionKeychain.fetch().expirationDate else { return false }
        return expirationDate <= .now
    }
}
