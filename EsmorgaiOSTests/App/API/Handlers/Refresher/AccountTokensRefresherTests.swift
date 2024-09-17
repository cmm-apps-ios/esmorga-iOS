//
//  AccountTokensRefresherTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
import Alamofire
@testable import EsmorgaiOS

final class AccountTokensRefresherTests: XCTestCase {

    private var sut: AccountTokensRefresher!
    private var credential: MockAccountCredential!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        credential = MockAccountCredential()
        sut = AccountTokensRefresher()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        credential = nil
        sut = nil
        try super.tearDownWithError()
    }

    private let sessionManager: Alamofire.Session = {
        let manager = Alamofire.Session(configuration: URLSessionConfiguration.default)
        manager.session.configuration.urlCache = URLCache.shared
        return manager
    }()

    func test_given_refresh_when_valid_refresh_token_and_success_response_then_store_new_tokens_correctly() {
        credential.mockTokens = AccountSession(accessToken: "token", refreshToken: "refresh", ttl: 600)
        stubRequest(file: "mock_refresh_token.json")
        var completed: Bool?

        sut.refreshTokens(sessionManager: sessionManager, credential: credential) { _, _, _ in
            completed = true
        }

        expect(completed).toEventually(beTrue())
        expect(self.credential.mockTokens).toEventuallyNot(beNil())
        expect(self.credential.mockTokens?.accessToken).toEventually(equal("ACCESS_TOKEN"))
        expect(self.credential.mockTokens?.refreshToken).toEventually(equal("REFRESH_TOKEN"))
    }

    func test_given_refresh_when_invalid_refresh_token_then_error_response_code_is_correctly_401() {
        var completed: Bool?
        var expectedResponseCode: Int?

        sut.refreshTokens(sessionManager: sessionManager, credential: credential) { _, responseCode, _ in
            expectedResponseCode = responseCode
            completed = true
        }

        expect(completed).toEventually(beTrue())
        expect(expectedResponseCode).toEventually(equal(401))
    }

    func test_given_refresh_when_valid_refresh_token_and_failure_response_then_error_response_code_is_correctly() {
        credential.mockTokens = AccountSession(accessToken: "token", refreshToken: "refresh", ttl: 600)
        stubRequest(statusCode: 500)
        var completed: Bool?
        var expectedResponseCode: Int?

        sut.refreshTokens(sessionManager: sessionManager, credential: credential) { _, responseCode, _ in
            expectedResponseCode = responseCode
            completed = true
        }

        expect(completed).toEventually(beTrue())
        expect(expectedResponseCode).toEventually(equal(500))
    }

    private func stubRequest(file: String = "mock_dummy_file.json", statusCode: Int = 200) {

        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/refresh") && isMethodPOST()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(statusCode),
                                     headers: ["Content-Type": "application/json"])
        }
    }
}

class MockAccountCredential: AccountCredential {

    var mockTokens: AccountSession?

    override var accessToken: String? { mockTokens?.accessToken }
    override var refreshToken: String? { mockTokens?.refreshToken }
    override func store(tokens: AccountSession) { mockTokens = tokens }
    override var requiresRefresh: Bool {
        guard let expirationDate = mockTokens?.expirationDate else { return false }
        return expirationDate <= .now
    }
}
