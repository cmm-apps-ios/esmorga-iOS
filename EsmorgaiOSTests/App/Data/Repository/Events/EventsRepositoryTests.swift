//
//  EventsRepositoryTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class EventsRepositoryTests {

    private var sut: EventsRepository!
    private var mockRemoteEventsDataSource: MockRemoteEventsDataSource!
    private var mockLocalEventsDataSource: MockLocalEventsDataSource!
    private var mockRemoteMyEventsDataSource: MockRemoteMyEventsDataSource!
    private var sessionKeychain: CodableKeychain<AccountSession>!

    init() {
        sessionKeychain = AccountSession.buildCodableKeychain()
        try? sessionKeychain.delete()
        mockRemoteEventsDataSource = MockRemoteEventsDataSource()
        mockLocalEventsDataSource = MockLocalEventsDataSource()
        mockRemoteMyEventsDataSource = MockRemoteMyEventsDataSource()
        sut = EventsRepository(remoteDataSource: mockRemoteEventsDataSource,
                               localEventsDataSource: mockLocalEventsDataSource,
                               remoteMyEventsDataSource: mockRemoteMyEventsDataSource,
                               sessionKeychain: sessionKeychain)
    }

    deinit {
        try? sessionKeychain.delete()
        sessionKeychain = nil
        mockRemoteEventsDataSource = nil
        mockLocalEventsDataSource = nil
        mockRemoteMyEventsDataSource = nil
        sut = nil
    }

    private func createSessionKeychain() {
        try? sessionKeychain.store(codable: AccountSession(accessToken: "fakeToken", refreshToken: "fakeRefresh", ttl: 1000))
    }

    private func buidRemoteEvent(eventId: String) -> RemoteEventListModel.Event {
        return RemoteEventListModel.Event(eventId: eventId,
                                          eventName: "Event name",
                                          eventDate: "2025-03-08T10:05:30.915Z",
                                          description: "Event description",
                                          eventType: "Party",
                                          imageUrl: nil,
                                          location: RemoteEventListModel.Event.Location(lat: 0.0, long: 0.0, name: "location"))
    }

    @Test
    func test_given_get_event_list_when_no_cache_and_success_response_then_return_correct_event_list() async {

        let event = buidRemoteEvent(eventId: "1234")
        mockRemoteEventsDataSource.mockEvents = [event]

        let result = try? await sut.getEventList(refresh: false)

        #expect(result?.0.count == 1)
        #expect(result?.0 == [event.toDomain()])
        #expect(result?.1 == false)
        #expect(self.mockLocalEventsDataSource.savedEvents == [event.toDomain()])
    }

    @Test
    func test_given_get_event_list_when_fresh_cache_then_return_stored_events() async {

        let events = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = events

        let result = try? await sut.getEventList(refresh: false)

        #expect(result?.0.count == 1)
        #expect(result?.0 == events)
        #expect(result?.1 == false)
    }

    @Test
    func test_given_get_event_list_when_no_fresh_cache_and_success_response_then_return_correct_event_list() async {

        let remoteEvent = buidRemoteEvent(eventId: "456")
        mockRemoteEventsDataSource.mockEvents = [remoteEvent]

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -40, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: false)

        #expect(result?.0.count == 1)
        #expect(result?.0 == [remoteEvent.toDomain()])
        #expect(result?.1 == false)
        #expect(self.mockLocalEventsDataSource.savedEvents == [remoteEvent.toDomain()])
    }

    @Test
    func test_given_get_event_list_when_fresh_cache_and_force_refresh_then_return_remote_events() async {

        let remoteEvent = buidRemoteEvent(eventId: "456")

        mockRemoteEventsDataSource.mockEvents = [remoteEvent]

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: true)

        #expect(result?.0.count == 1)
        #expect(result?.0 == [remoteEvent.toDomain()])
        #expect(result?.1 == false)
        #expect(self.mockLocalEventsDataSource.savedEvents == [remoteEvent.toDomain()])
    }

    @Test
    func test_given_get_event_list_when_remote_fail_with_no_connection_cache_and_force_refresh_then_return_stored_events() async {

        mockRemoteEventsDataSource.mockError = NetworkError.noInternetConnection

        let localEvents = [EventBuilder().with(creationDate: Calendar.current.date(byAdding: .minute, value: -10, to: .now)!).build()]
        mockLocalEventsDataSource.mockEvents = localEvents

        let result = try? await sut.getEventList(refresh: true)

        #expect(result?.0.count == 1)
        #expect(result?.0 == localEvents)
        #expect(result?.1 == true)
    }

    @Test
    func test_given_get_event_list_when_remote_fail_with_general_error_then_return_correct_error() async {

        do {
            _ = try await sut.getEventList(refresh: true)
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }

    @Test
    func func_test_given_logged_user_when_request_all_events_then_events_isUserJoined_is_marked_correctly() async {
        mockRemoteEventsDataSource.mockEvents = [buidRemoteEvent(eventId: "123"),
                                                 buidRemoteEvent(eventId: "456"),
                                                 buidRemoteEvent(eventId: "789"),
                                                 buidRemoteEvent(eventId: "012")]

        mockRemoteMyEventsDataSource.mockEvents = [buidRemoteEvent(eventId: "456"),
                                                   buidRemoteEvent(eventId: "012")]
        createSessionKeychain()

        let result = try? await sut.getEventList(refresh: false)

        #expect(result?.0.count == 4)
        #expect(result?.0[0].isUserJoined == false)
        #expect(result?.0[1].isUserJoined == true)
        #expect(result?.0[2].isUserJoined == false)
        #expect(result?.0[3].isUserJoined == true)

        #expect(self.mockLocalEventsDataSource.savedEvents?[0].isUserJoined == false)
        #expect(self.mockLocalEventsDataSource.savedEvents?[1].isUserJoined == true)
        #expect(self.mockLocalEventsDataSource.savedEvents?[2].isUserJoined == false)
        #expect(self.mockLocalEventsDataSource.savedEvents?[3].isUserJoined == true)
    }

    @Test
    func test_given_get_event_list_when_user_is_logged_and_user_remote_fail_with_general_error_then_return_correct_error() async {

        mockRemoteEventsDataSource.mockEvents = [buidRemoteEvent(eventId: "123")]
        createSessionKeychain()

        do {
            _ = try await sut.getEventList(refresh: true)
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
}
