//
//  MyEventsViewModelTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/9/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class MyEventsViewModelTests {
    private var sut: MyEventsViewModel!
    private var mockGetEventListUseCase: MockGetEventListUseCase!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!

    init() {
        mockGetEventListUseCase = MockGetEventListUseCase()
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = MyEventsViewModel(coordinator: spyCoordinator,
                                networkMonitor: mockNetworkMonitor,
                                getEventListUseCase: mockGetEventListUseCase,
                                getLocalUserUseCase: mockGetLocalUserUseCase)
    }

    deinit {
        mockGetEventListUseCase = nil
        mockGetLocalUserUseCase = nil
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }

    @Test
    func test_given_get_event_list_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: true).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: true).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        await sut.getEventList(forceRefresh: false)

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(self.sut.snackBar.isShown == false)
    }

    @Test
    func test_given_event_tapped_then_navigate_to_details_is_called() {

        let event = EventBuilder().with(eventId: "1").with(isUserJoined: true).build()

        sut.eventTapped(event)

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .eventDetails(event))
    }

    @Test
    func test_given_get_event_list_when_failure_then_error_is_shown() async {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        await sut.getEventList(forceRefresh: false)

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .error)
        #expect(self.sut.snackBar.isShown == false)
    }

    @Test
    func test_given_get_event_list_when_not_logged_then_state_logged_out_is_set() async {

        await sut.getEventList(forceRefresh: false)

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.snackBar.isShown == false)
    }

    @Test
    func test_given_login_button_tapped_then_navigate_to_login_is_called() {

        sut.loginButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .login)
    }

    @Test
    func test_given_retry_button_tapped_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: true).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: true).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        await sut.retryButtonTapped()

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(self.sut.snackBar.isShown == false)
    }

    @Test
    func test_given_retry_button_tapped_when_success_but_not_joined_then_state_empty_is_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: false).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: false).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        await sut.retryButtonTapped()

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .empty)
    }

    @Test
    func test_given_retry_button_tapped_when_no_connection_then_show_error_screen() async {

        mockNetworkMonitor.mockIsConnected = false

        await sut.retryButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .noInternet)))
    }
}
