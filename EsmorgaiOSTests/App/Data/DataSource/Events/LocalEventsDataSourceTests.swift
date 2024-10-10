//
//  LocalEventsDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//
import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class LocalEventsDataSourceTests {

    private var sut: LocalEventsDataSource!

    init() {
        sut = LocalEventsDataSource()
        sut.clearAll()
    }

    deinit {
        sut.clearAll()
        sut = nil
    }

    @Test
    func tests_given_get_events_when_empty_cache_then_return_empty_result() async {
        let result = await sut.getEvents()
        #expect(result.isEmpty)
    }

    @Test
    func test_given_get_events_when_cache_data_then_return_events() async {
        let events = [EventBuilder().build()]
        try? await sut.saveEvents(events)
        let result = await sut.getEvents()
        #expect(result == events)
    }

    @Test
    func test_test() async {
        let event = EventBuilder().build()
        try? await sut.saveEvents([event])
        try? await sut.updateEvent(id: event.eventId, isUserJoined: true)
        let storeEvent = await sut.getEvents().first
        #expect(storeEvent?.isUserJoined == true)
    }
}
