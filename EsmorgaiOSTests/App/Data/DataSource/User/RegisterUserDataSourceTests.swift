//
//  RegisterUserDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS

final class RegisterUserDataSourceTests: XCTestCase {

    private var sut: RegisterUserDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut = RegisterUserDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_login_when_success_response_then_return_correct_user() async {
        stubRequest(file: "mock_account_login.json")
        let results = try? await sut.register(name: "name", lastName: "lastName", pass: "Secret!1", email: "test@yopmail.com")
        expect(results).toNot(beNil())
    }

    func test_given_login_when_failure_response_then_return_correct_error() async {

        stubErrorRequest(code: 500)

        do {
            _ = try await sut.register(name: "name", lastName: "lastName", pass: "Secret!1", email: "test@yopmail.com")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/account/register") && isMethodPOST()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(200),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/account/register") && isMethodPOST()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
