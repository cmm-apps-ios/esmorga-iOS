//
//  AccountCredentialTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//


import XCTest
import Nimble
import Alamofire
@testable import EsmorgaiOS

class AccountCredentialTests: XCTestCase {

    private var sut: AccountCredential!
    private var sessionKeychain: CodableKeychain<AccountSession>!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sessionKeychain = AccountSession.buildCodableKeychain()
        sut = AccountCredential(accountSessionKeychain: sessionKeychain)
    }

    override func tearDownWithError() throws {
        try sessionKeychain.delete()
        sessionKeychain = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_store_credentials_then_return_correct_values() throws {

        expect(self.sut.accessToken).to(beNil())
        expect(self.sut.refreshToken).to(beNil())
        expect(self.sut.requiresRefresh).to(beFalse())

        let session = AccountSession(accessToken: "accessToken", refreshToken: "refreshToken", ttl: 110)

        try sut.store(tokens: session)

        expect(self.sut.accessToken).to(equal(session.accessToken))
        expect(self.sut.refreshToken).to(equal(session.refreshToken))
        expect(self.sut.requiresRefresh).to(beFalse())

        let sessionExpired = AccountSession(accessToken: "expiredAccessToken", refreshToken: "expiredRefreshTokem", ttl: -110)

        try sut.store(tokens: sessionExpired)

        print(sessionExpired)

        expect(self.sut.accessToken).to(equal(sessionExpired.accessToken))
        expect(self.sut.refreshToken).to(equal(sessionExpired.refreshToken))
        expect(self.sut.requiresRefresh).to(beTrue())
    }
}
