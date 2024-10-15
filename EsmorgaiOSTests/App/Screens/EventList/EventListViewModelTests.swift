//
//  EventListViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class EventListViewModelTests {

    private var sut: EventListViewModel!
    private var mockGetEventListUseCase: MockGetEventListUseCase!
    private var spyCoordinator: SpyCoordinator!

    init() {
        mockGetEventListUseCase = MockGetEventListUseCase()
        spyCoordinator = SpyCoordinator()
        sut = EventListViewModel(coordinator: spyCoordinator,
                                 getEventListUseCase: mockGetEventListUseCase)
    }

    deinit {
        mockGetEventListUseCase = nil
        spyCoordinator = nil
        sut = nil
    }

    @MainActor
    @Test
    func test_given_get_event_list_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").build(),
                      EventBuilder().with(eventId: "2").build()]

        mockGetEventListUseCase.mockResponse = (events, false)

        await TestHelper.fullfillTask {
            await self.sut.getEventList(forceRefresh: false)
        }

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(!self.sut.snackBar.isShown)
    }

    @MainActor
    @Test
    func test_given_get_event_list_when_success_from_cache_then_events_are_correct_and_snackbar_is_shown() async {

        let events = [EventBuilder().with(eventId: "1").build(),
                      EventBuilder().with(eventId: "2").build()]

        mockGetEventListUseCase.mockResponse = (events, true)

        await TestHelper.fullfillTask {
            await self.sut.getEventList(forceRefresh: false)
        }

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(self.sut.snackBar.isShown)
    }

    @MainActor
    @Test
    func test_given_get_event_list_when_failuer_then_error_is_shown() async {

        await TestHelper.fullfillTask {
            await self.sut.getEventList(forceRefresh: false)
        }

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .error)
        #expect(!self.sut.snackBar.isShown)
    }

    @Test
    func test_given_event_tapped_then_navigate_to_details_is_called() {

        let event = EventBuilder().with(eventId: "1").build()

        sut.eventTapped(event)

        #expect(self.spyCoordinator.pushCalled)
        #expect(self.spyCoordinator.destination == .eventDetails(event))
    }
}
