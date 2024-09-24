//
//  RemoteMyEventsDataSourceTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 24/9/24.
//

import Testing
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS

@Suite(.serialized)
final class RemoteMyEventsDataSourceTests {

    private var sut: RemoteMyEventsDataSource!
    private var sessionKeychain: CodableKeychain<AccountSession>!

    init() {
        HTTPStubs.removeAllStubs()
        sessionKeychain = AccountSession.buildCodableKeychain()
        try? sessionKeychain.delete()
        sut = RemoteMyEventsDataSource()
    }

    deinit {
        HTTPStubs.removeAllStubs()
        try? sessionKeychain.delete()
        sessionKeychain = nil
        sut = nil
    }

    @Test
    func test_given_get_my_events_when_success_response_then_events_are_not_nil() async {

        createSessionKeychain()
        stubRequest(file: "mock_event_list.json")
        let results = try? await sut.fetchEvents()
        #expect(results != nil)
        #expect(results?.count == 9)
    }

    @Test
    func test_given_get_my_event_when_remote_fail_with_general_error_then_return_correct_error() async {

        createSessionKeychain()
        stubErrorRequest(code: 500)
        do {
            _ = try await sut.fetchEvents()
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }

    @Test
    func test_given_get_my_even_when_remote_fail_with_no_connection_then_return_correct_error() async {

        createSessionKeychain()
        stubErrorRequest(code: NSURLErrorNotConnectedToInternet)
        do {
            _ = try await sut.fetchEvents()
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.noInternetConnection)
        }
    }

    private func createSessionKeychain() {
        try? sessionKeychain.store(codable: AccountSession(accessToken: "fakeToken", refreshToken: "fakeRefresh", ttl: 1000))
    }

    private func stubRequest(file: String) {

        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/events") && isMethodGET()) { _ in
            return HTTPStubsResponse(fileAtPath: OHPathForFile(file, type(of: self))!,
                                     statusCode: Int32(200),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(code: Int) {
        stub(condition: isHost("qa.esmorga.canarte.org") && isPath("/v1/account/events") && isMethodGET()) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}