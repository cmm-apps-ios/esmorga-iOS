//
//  RemotePollsDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Marcelo Moran on 29/9/26.
//

import Nimble
import XCTest
import OHHTTPStubs
import OHHTTPStubsSwift
@testable import EsmorgaiOS

final class RemotePollsDataSourceTests: XCTestCase {

    private var sut: RemotePollsDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        HTTPStubs.removeAllStubs()
        sut = RemotePollsDataSource()
    }

    override func tearDownWithError() throws {
        HTTPStubs.removeAllStubs()
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_fetch_polls_when_success_response_then_polls_are_not_nil() async {

        stubRequest(path: "/v1/polls", data: Self.pollListData)
        let results = try? await sut.fetchPolls()
        expect(results).toNot(beNil())
        expect(results?.count).to(equal(2))
    }

    func test_given_fetch_polls_when_remote_fail_with_general_error_then_return_correct_error() async {

        stubErrorRequest(path: "/v1/polls", code: 500)

        do {
            _ = try await sut.fetchPolls()
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    func test_given_fetch_polls_when_remote_fail_with_no_connection_then_return_correct_error() async {

        stubErrorRequest(path: "/v1/polls", code: NSURLErrorNotConnectedToInternet)

        do {
            _ = try await sut.fetchPolls()
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.noInternetConnection))
        }
    }

    func test_given_send_vote_when_success_response_then_poll_is_returned() async {

        let voteRequest = VotePollRequest(pollId: "1234", selectedOptionIds: ["opt1"])
        stubRequest(path: "/v1/polls/1234/vote", data: Self.singlePollData)
        let result = try? await sut.sendVote(vote: voteRequest)

        expect(result).toNot(beNil())
        expect(result?.toDomain().id).to(equal("1234"))
    }

    func test_given_send_vote_when_remote_fail_with_general_error_then_return_correct_error() async {

        let voteRequest = VotePollRequest(pollId: "1234", selectedOptionIds: ["opt1"])
        stubErrorRequest(path: "/v1/polls/1234/vote", code: 500)

        do {
            _ = try await sut.sendVote(vote: voteRequest)
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    private static var singlePoll: [String: Any] {
        return ["pollId": "1234",
               "pollName": "Preferred pizza",
               "description": "Which pizza do you prefer?",
               "options": [["optionId": "opt1",
                            "option": "Margherita",
                            "voteCount": 3]],
               "voteDeadline": "2026-10-31T23:59:59.000Z",
               "isMultipleChoice": true,
               "userSelectedOptions": []]
    }

    private static var singlePollData: Data {
        return try! JSONSerialization.data(withJSONObject: singlePoll, options: [])
    }

    private static var pollListData: Data {
        return try! JSONSerialization.data(withJSONObject: ["totalPolls": 2,
                                                            "polls": [singlePoll,
                                                                      ["pollId": "5678",
                                                                       "pollName": "Event date",
                                                                       "description": "When should the event be?",
                                                                       "options": [["optionId": "opt3",
                                                                                    "option": "Monday",
                                                                                    "voteCount": 2]],
                                                                       "voteDeadline": "2026-09-30T08:00:00.000Z",
                                                                       "isMultipleChoice": false,
                                                                        "userSelectedOptions": ["opt3"]]]],
                                                             options: [])
    }

    private func stubRequest(path: String, data: Data) {

        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath(path)) { _ in
            return HTTPStubsResponse(data: data,
                                     statusCode: Int32(200),
                                     headers: ["Content-Type": "application/json"])
        }
    }

    private func stubErrorRequest(path: String, code: Int) {

        stub(condition: isHost("qa.api.esmorgaevents.com") && isPath(path)) { _ in
            let error = NSError(domain: NSURLErrorDomain, code: code, userInfo: nil)
            return HTTPStubsResponse(error: error)
        }
    }
}
