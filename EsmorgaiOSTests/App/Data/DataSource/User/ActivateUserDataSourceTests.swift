//
//  ActivateAccountUserDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 26/5/25.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS


//Los dejo aqui, pero parece que los estoy planteando mal
final class ActivateUserDataSourceTests: XCTestCase {

    private var sut: ActivateUserDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut =  ActivateUserDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_activate_when_success_response_then_return_user() async {

        stubRequest(file: "mock_account_login.json")

        let results = try? await sut.activate(code: "123456")
        expect(results).toNot(beNil())
    }


    func test_given_activate_when_failure_response_then_return_correct_error() async {

        stubErrorRequest(code: 500)

        do {
            _ = try await sut.activate(code: "123456")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/account/activate") && isMethodPUT()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(204),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/account/activate") && isMethodPUT()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
