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

    //MOB-TC-150
    @MainActor
    @Test
    func test_given_get_event_list_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: true).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: true).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        let task = Task {
            await sut.getEventList(forceRefresh: false)
        }

        await task.value

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

    //MOB-TC-155
    @MainActor
    @Test
    func test_given_get_event_list_when_failure_then_error_is_shown() async {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        let task = Task {
            await sut.getEventList(forceRefresh: false)
        }

        await task.value

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .error)
        #expect(self.sut.snackBar.isShown == false)
    }

    @MainActor
    @Test
    func test_given_get_event_list_when_not_logged_then_state_logged_out_is_set() async {

        let task = Task {
            await sut.getEventList(forceRefresh: false)
        }

        await task.value

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.snackBar.isShown == false)
    }

    //MOB-TC-152
    @Test
    func test_given_login_button_tapped_then_navigate_to_login_is_called() {

        sut.loginButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .login)
    }

    @MainActor
    @Test
    func test_given_retry_button_tapped_when_success_then_events_are_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: true).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: true).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        let task = Task {
            await sut.retryButtonTapped()
        }

        await task.value

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(self.sut.snackBar.isShown == false)
    }

    //MOB-TC-154
    @MainActor
    @Test
    func test_given_retry_button_tapped_when_success_but_not_joined_then_state_empty_is_correct() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: false).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: false).build()]

        mockGetEventListUseCase.mockResponse = (events, false)
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        let task = Task {
            await sut.retryButtonTapped()
        }

        await task.value

        #expect(self.sut.events.isEmpty)
        #expect(self.sut.state == .empty)
    }

    //MOB-TC-156
    @MainActor
    @Test
    func test_given_my_events_list_when_success_from_cache_then_events_are_correct_and_snackbar_is_shown() async {

        let events = [EventBuilder().with(eventId: "1").with(isUserJoined: true).build(),
                      EventBuilder().with(eventId: "2").with(isUserJoined: true).build()]

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        mockGetEventListUseCase.mockResponse = (events, true)

        let task = Task {
            await sut.getEventList(forceRefresh: false)
        }

        await task.value

        #expect(self.sut.events == events)
        #expect(self.sut.state == .loaded)
        #expect(self.sut.snackBar.isShown == true)
    }

    @MainActor
    @Test
    func test_given_retry_button_tapped_when_no_connection_then_show_error_screen() async {

        mockNetworkMonitor.mockIsConnected = false

        await sut.retryButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .noInternet)))
    }
}
