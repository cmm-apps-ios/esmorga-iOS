//
//  ResetPasswordDataSourceTests.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/6/25.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS


final class ResetPasswordDataSourceTests: XCTestCase {

    private var sut: ResetPasswordUserDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut =  ResetPasswordUserDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_verify_when_success_response_then_return_correct_mail() async {
        stubRequest(file: "mock_empty_file.json")
        let results: ()? = try? await sut.resetPassword(pass: "Mobgen!2", code: "123456")
        expect(results).toNot(beNil())
    }

    func test_given_verify_when_failure_response_then_return_generic_error() async {

        stubErrorRequest(code: 500)

        do {
            _ = try await sut.resetPassword(pass: "Mobgen!1", code: "123456")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/password/forgot-init") && isMethodPOST()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(204),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/password/forgot-init") && isMethodPOST()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
