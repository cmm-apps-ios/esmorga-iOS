//
//  EventsRepositoryTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class EventsRepositoryTests: XCTestCase {

    private var sut: EventsRepository!
    private var mockRemoteEventsDataSource: MockRemoteEventsDataSource!
    private var mockLocalEventsDataSource: MockLocalEventsDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockRemoteEventsDataSource = MockRemoteEventsDataSource()
        mockLocalEventsDataSource = MockLocalEventsDataSource()
        sut = EventsRepository(remoteDataSource: mockRemoteEventsDataSource,
                               localEventsDataSource: mockLocalEventsDataSource)
    }

    override func tearDownWithError() throws {
        mockRemoteEventsDataSource = nil
        mockLocalEventsDataSource = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_event_list_when_no_cache_and_success_response_then_return_correct_event_list() async {

        let event = RemoteEventListModel.Event(eventId: "1234",
                                               eventName: "Event name",
                                               eventDate: "2025-03-08T10:05:30.915Z",
                                               description: "Event description",
                                               eventType: "Party",
                                               imageUrl: nil,
                                               location: RemoteEventListModel.Event.Location(lat: 0.0, long: 0.0, name: "location"))

        mockRemoteEventsDataSource.mockEvents = [event]

        let result = try? await sut.getEventList(refresh: false)

        expect(result?.0.count).to(equal(1))
        expect(result?.0).to(equal([event.toDomain()]))
        expect(result?.1).to(beFalse())
        expect(self.mockLocalEventsDataSource.savedEvents).to(equal([event.toDomain()]))
    }

    func test_given_get_event_list_when_fresh_cache_then_return_stored_events() async {

        let events = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = events

        let result = try? await sut.getEventList(refresh: false)

        expect(result?.0.count).to(equal(1))
        expect(result?.0).to(equal(events))
        expect(result?.1).to(beFalse())
    }

    func test_given_get_event_list_when_no_fresh_cache_and_success_response_then_return_correct_event_list() async {

        let remoteEvent = RemoteEventListModel.Event(eventId: "456",
                                                     eventName: "Event name",
                                                     eventDate: "2025-03-08T10:05:30.915Z",
                                                     description: "Event description",
                                                     eventType: "Party",
                                                     imageUrl: nil,
                                                     location: RemoteEventListModel.Event.Location(lat: 0.0, long: 0.0, name: "location"))

        mockRemoteEventsDataSource.mockEvents = [remoteEvent]

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -40, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: false)

        expect(result?.0.count).to(equal(1))
        expect(result?.0).to(equal([remoteEvent.toDomain()]))
        expect(result?.1).to(beFalse())
        expect(self.mockLocalEventsDataSource.savedEvents).to(equal([remoteEvent.toDomain()]))
    }

    func test_given_get_event_list_when_fresh_cache_and_force_refresh_then_return_remote_events() async {

        let remoteEvent = RemoteEventListModel.Event(eventId: "456",
                                                     eventName: "Event name",
                                                     eventDate: "2025-03-08T10:05:30.915Z",
                                                     description: "Event description",
                                                     eventType: "Party",
                                                     imageUrl: nil,
                                                     location: RemoteEventListModel.Event.Location(lat: 0.0, long: 0.0, name: "location"))

        mockRemoteEventsDataSource.mockEvents = [remoteEvent]

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: true)

        expect(result?.0.count).to(equal(1))
        expect(result?.0).to(equal([remoteEvent.toDomain()]))
        expect(result?.1).to(beFalse())
        expect(self.mockLocalEventsDataSource.savedEvents).to(equal([remoteEvent.toDomain()]))
    }

    func test_given_get_event_list_when_remote_fail_with_no_connection_cache_and_force_refresh_then_return_stored_events() async {

        mockRemoteEventsDataSource.mockError = NetworkError.noInternetConnection

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: true)

        expect(result?.0.count).to(equal(1))
        expect(result?.0).to(equal(localEvents))
        expect(result?.1).to(beTrue())
    }

    func test_given_get_event_list_when_remote_fail_with_general_error_then_return_correct_error() async {

        do {
            _ = try await sut.getEventList(refresh: true)
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.genaralError(code: 500)))
        }
    }
}
