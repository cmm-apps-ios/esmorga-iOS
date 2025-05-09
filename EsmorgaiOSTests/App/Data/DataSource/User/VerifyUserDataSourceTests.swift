//
//  VerifyUserDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 7/5/25.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS


//Los dejo aqui, pero parece que los estoy planteando mal
final class VerifyUserDataSourceTests: XCTestCase {

    private var sut: VerifyUserDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut =  VerifyUserDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_verify_when_success_response_then_return_correct_mail() async {
        stubRequest(file: "mock_dummy_file.json")//-> para que quiero este file
        let results: ()? = try? await sut.verify(email: "test@yopmail.com")
        expect(results).toNot(beNil()) //-> devuelve (), no es nil
    }

    func test_given_verify_when_failure_response_then_return_generic_error() async {

        stubErrorRequest(code: 500)

        do {
            _ = try await sut.verify(email: "testemailconfirm@yopmail.com")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/email/verification") && isMethodPOST()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(204),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/email/verification") && isMethodPOST()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
