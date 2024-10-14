//
//  AccountAuthenticatorTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 17/9/24.
//

import XCTest
import Nimble
import Alamofire
@testable import EsmorgaiOS

class AccountAuthenticatorTests: XCTestCase {

    private var sessionKeychain: CodableKeychain<AccountSession>!
    private var credential: AccountCredential!
    private var refresher: MockAccountTokensRefresher!
    private var sut: AccountAuthenticator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sessionKeychain = AccountSession.buildCodableKeychain()
        try sessionKeychain.delete()
        credential = AccountCredential(accountSessionKeychain: sessionKeychain)
        refresher = MockAccountTokensRefresher()
        sut = AccountAuthenticator(refresher: refresher)
    }

    override func tearDownWithError() throws {
        try sessionKeychain.delete()
        sessionKeychain = nil
        credential = nil
        refresher = nil
        sut = nil
        try super.tearDownWithError()
    }

    private let sessionManager: Alamofire.Session = {
        let manager = Alamofire.Session(configuration: URLSessionConfiguration.default)
        manager.session.configuration.urlCache = URLCache.shared
        return manager
    }()

    func test_given_refresh_success_then_return_credentials() {

        refresher.mockResult = (true, 200, nil)
        var done: Bool = false
        var accountCredential: AccountCredential?

        sut.refresh(credential, for: sessionManager) { (result) in
            switch result {
            case .success(let credential):
                done = true
                accountCredential = credential
            case .failure:
                XCTFail("Unexpected error thrown")
            }
        }

        expect(done).toEventually(beTrue())
        expect(accountCredential).toEventuallyNot(beNil())
    }

    func test_given_refresh_fail_then_return_error() {

        var done: Bool = false
        var expectedError: Error?

        sut.refresh(credential, for: sessionManager) { (result) in

            switch result {
            case .success:
                XCTFail("Expected error to be thrown")
            case .failure(let error):
                done = true
                expectedError = error
            }
        }

        expect(done).toEventually(beTrue())
        expect(expectedError).toEventuallyNot(beNil())
    }

    func test_given_apply_credential_to_url_request_when_session_available_then_apply_bearer_header() throws {
        let session = AccountSession(accessToken: "accessToken", refreshToken: "refreshToken", ttl: 110)
        try? credential.store(tokens: session)
        var request = try URLRequest(url: URL(string: "www.esmorga.com")!, method: .get)

        sut.apply(credential, to: &request)

        expect(request.headers["Authorization"]).toEventually(equal("Bearer accessToken"))
    }

    func test_given_apply_credential_to_url_request_when_no_session_available_then_not_apply_bearer_header() throws {

        var request = try URLRequest(url: URL(string: "www.esmorga.com")!, method: .get)

        sut.apply(credential, to: &request)

        expect(request.headers["Authorization"]).toEventually(beNil())
    }
}

class MockAccountTokensRefresher: AccountTokensRefresher {

    var mockResult: (Bool, Int, Error?) = (false, 500, nil)

    override func refreshTokens(sessionManager: Alamofire.Session,
                       credential: AccountCredential,
                       completion: @escaping (_ succeeded: Bool, _ responseCode: Int, _ error: Error?) -> Void) {
        completion(mockResult.0, mockResult.1, mockResult.2)
    }
}
