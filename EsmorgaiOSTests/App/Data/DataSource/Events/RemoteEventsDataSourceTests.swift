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

    func test_given_get_events_when_success_response_then_events_are_not_nil() async {

        stubRequest(file: "mock_event_list.json")
        let results = try? await sut.fetchEvents()
        expect(results).toNot(beNil())
    }

    func test_given_get_events_when_success_response_but_incorrect_format_then_mapping_error_is_throw() async {

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
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
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

        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/events") && isMethodGET()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(200),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath("/v1/events") && isMethodGET()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
