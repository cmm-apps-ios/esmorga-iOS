//
//  EventListViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class EventListViewModelTests: XCTestCase {

    private var sut: EventListViewModel!
    private var mockGetEventListUseCase: MockGetEventListUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockGetEventListUseCase = MockGetEventListUseCase()
        sut = EventListViewModel(getEventListUseCase: mockGetEventListUseCase)
    }

    override func tearDownWithError() throws {
        mockGetEventListUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_event_list_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").build(),
                      EventBuilder().with(eventId: "2").build()]

        mockGetEventListUseCase.mockResponse = (events, false)

        sut.getEventList(forceRefresh: false)

        await expect(self.sut.events).toEventually(equal(events))
        await expect(self.sut.hasError).toEventually(beFalse())
        await expect(self.sut.showSnackbar).toEventually(beFalse())
    }

    func test_given_get_event_list_when_success_from_cache_then_events_are_correct_and_snackbar_is_shown() async {

        let events = [EventBuilder().with(eventId: "1").build(),
                      EventBuilder().with(eventId: "2").build()]

        mockGetEventListUseCase.mockResponse = (events, true)

        sut.getEventList(forceRefresh: false)

        await expect(self.sut.events).toEventually(equal(events))
        await expect(self.sut.hasError).toEventually(beFalse())
        await expect(self.sut.showSnackbar).toEventually(beTrue())
    }

    func test_given_get_event_list_when_failuer_then_error_is_shown() async {

        sut.getEventList(forceRefresh: false)

        await expect(self.sut.events).toEventually(beEmpty())
        await expect(self.sut.hasError).toEventually(beTrue())
        await expect(self.sut.showSnackbar).toEventually(beFalse())
    }
}