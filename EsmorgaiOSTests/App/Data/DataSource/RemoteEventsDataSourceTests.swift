//
//  RemoteEventsDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS

final class RemoteEventsDataSourceTests: XCTestCase {

    private var sut: RemoteEventsDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut = RemoteEventsDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_test() async {

        stubRequest(file: "mock_event_list.json")
        let results = try? await sut.fetchEvents()
        expect(results).toNot(beNil())
    }

    func test_tes2() async {

        stubRequest(file: "mock_dummy_file.json")
        do {
            _ = try await sut.fetchEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.mappingError))
        }
    }


    func test_given_get_event_list_when_remote_fail_with_general_error_then_return_correct_error() async {

        stubErrorRequest(code: 500)

        do {
            _ = try await sut.fetchEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.genaralError(code: 500)))
        }
    }

    func test_given_get_event_list_when_remote_fail_with_no_connection_then_return_correct_error() async {

        stubErrorRequest(code: NSURLErrorNotConnectedToInternet)

        do {
            _ = try await sut.fetchEvents()
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.noInternetConnection))
        }
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/events") && isMethodGET()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(200),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/events") && isMethodGET()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
