//
//  EventDetailsViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class EventDetailsViewModelTests {

    private var sut: EventDetailsViewModel!
    private var spyCoordinator: SpyCoordinator!
    private var mockNavigationManager: MockExternalAppsManager!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!
    private var mockJoinEventUseCase: MockJoinEventUseCase!
    private var mockLeaveEventUseCase: MockLeaveEventUseCase!
    private var mockGetEventAttendeesUseCase: MockGetEventAttendeesUseCase!
    private var mockNetworkMonitor: MockNetworkMonitor!

    init() {
        spyCoordinator = SpyCoordinator()
        mockNavigationManager = MockExternalAppsManager()
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        mockJoinEventUseCase = MockJoinEventUseCase()
        mockLeaveEventUseCase = MockLeaveEventUseCase()
        mockGetEventAttendeesUseCase = MockGetEventAttendeesUseCase()
        mockNetworkMonitor = MockNetworkMonitor()
    }

    deinit {
        spyCoordinator = nil
        mockNavigationManager = nil
        mockGetLocalUserUseCase = nil
        mockJoinEventUseCase = nil
        mockLeaveEventUseCase = nil
        mockGetEventAttendeesUseCase = nil
        mockNetworkMonitor = nil
        sut = nil
    }

    @Test
    func test_given_open_maps_button_tapped_when_only_one_method_then_open_navigation_is_called() {

        giveSut(event: EventBuilder().with(latitude: 40.4165).with(longitude: -3.70256).build())

        sut.openLocation()

        #expect(self.spyCoordinator.openAppCalled == true)
    }

    @Test
    func test_given_open_maps_button_tapped_when_more_than_one_method_then_alert_is_shonw() {

        mockNavigationManager.methods = [DeepLinkModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!),
                                         DeepLinkModels.Method(title: "Google Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

        giveSut(event: EventBuilder().with(latitude: 40.4165).with(longitude: -3.70256).build())

        sut.openLocation()

        #expect(self.sut.showMethodsAlert == true)
    }

    @Test("MOB-TC-186")
    func test_given_primary_button_tapped_when_user_not_logged_then_login_destination_is_push() async {

        giveSut(event: EventBuilder().build())

        sut.state = .loaded(isLogged: false)

        await sut.primaryButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .login)
    }

    @MainActor
    @Test
    func test_given_view_load_when_user_loggin_and_event_not_joined_then_display_join_event_button() async {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.title == event.name)
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())
    }

    @MainActor
    @Test
    func test_given_view_load_when_user_loggin_and_event_joined_then_display_leave_event_button() async {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().with(isUserJoined: true).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.title == event.name)
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())
    }

    @MainActor
    @Test
    func test_given_view_load_when_user_not_loggin_then_display_login_button() async {

        let event = EventBuilder().with(isUserJoined: true).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: false))
        #expect(self.sut.model.title == event.name)
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.loginToJoin.localize())
    }

    @MainActor
    @Test("MOB-TC-194 && MOB-TC-196 && MOB-TC-199")
    func test_given_not_joined_event_when_tap_primary_button_and_success_is_get_then_button_text_is_updated_and_snackbar_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())

        mockJoinEventUseCase.mockResult = true

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())
        #expect(self.sut.snackBar.isShown == true)
        #expect(self.sut.snackBar.message == LocalizationKeys.Snackbar.eventJoined.localize())
    }

    @MainActor
    @Test("MOB-TC-195 && MOB-TC-200")
    func test_given_not_joined_event_when_tap_primary_button_and_error_is_throw_then_common_error_dialog_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())

        mockJoinEventUseCase.mockResult = false

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())
        #expect(self.sut.snackBar.isShown == false)
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .commonError)))
    }

    @MainActor
    @Test
    func test_given_not_joined_event_when_tap_primary_button_and_not_internet_then_no_connection_dialog_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())

        mockNetworkMonitor.mockIsConnected = false

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())
        #expect(self.sut.snackBar.isShown == false)
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .noInternet)))
    }
    
    @MainActor
    @Test("MOB-TC-188 && MOB-TC-191 && MOB-TC-201")
    func test_given_joined_event_when_tap_primary_button_and_success_is_get_then_button_text_is_updated_and_snackbar_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().with(isUserJoined: true).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())

        mockLeaveEventUseCase.mockResult = true

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.joinEvent.localize())
        #expect(self.sut.snackBar.isShown == true)
        #expect(self.sut.snackBar.message == LocalizationKeys.Snackbar.eventLeft.localize())
    }

    @MainActor
    @Test("MOB-TC-187 && MOB-TC-192")
    func test_given_joined_event_when_tap_primary_button_and_error_is_throw_then_common_error_dialog_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().with(isUserJoined: true).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())

        mockJoinEventUseCase.mockResult = false

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())
        #expect(self.sut.snackBar.isShown == false)
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .commonError)))
    }

    @MainActor
    @Test
    func test_given_joined_event_when_tap_primary_button_and_not_internet_then_no_connection_dialog_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        let event = EventBuilder().with(isUserJoined: true).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.state == .loaded(isLogged: true))
        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())

        mockNetworkMonitor.mockIsConnected = false

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())
        #expect(self.sut.snackBar.isShown == false)
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .noInternet)))
    }

    @MainActor
    @Test
    func test_given_view_load_when_logged_in_then_attendees_count_comes_from_attendees_list() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        mockGetEventAttendeesUseCase.mockAttendees = [EventAttendee(name: "Alice", hasPayed: false),
                                                    EventAttendee(name: "Bob", hasPayed: true)]
        let event = EventBuilder().with(maxCapacity: 12).build()
        giveSut(event: event)

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.attendeesText == LocalizationKeys.EventDetails.attendeesCount.localize(2, 12))
    }

    @MainActor
    @Test
    func test_given_view_load_when_admin_and_attendees_exist_then_see_attendees_button_is_shown() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().with(role: .admin).build()
        mockGetEventAttendeesUseCase.mockAttendees = [EventAttendee(name: "Alice", hasPayed: false)]
        giveSut(event: EventBuilder().with(maxCapacity: 12).build())

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        #expect(self.sut.showSeeAttendeesButton == true)
    }

    @MainActor
    @Test
    func test_given_joined_event_when_join_succeeds_then_attendees_count_is_incremented() async {
        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()
        mockJoinEventUseCase.mockResult = true
        mockGetEventAttendeesUseCase.mockAttendees = [EventAttendee(name: "Alice", hasPayed: false)]
        giveSut(event: EventBuilder().with(maxCapacity: 12).build())

        await TestHelper.fullfillTask {
            await self.sut.viewLoad()
        }

        await TestHelper.fullfillTask {
            await self.sut.primaryButtonTapped()
        }

        #expect(self.sut.model.primaryButton.title == LocalizationKeys.Buttons.leaveEvent.localize())
        #expect(self.sut.attendeesText == LocalizationKeys.EventDetails.attendeesCount.localize(1, 12))
    }

    private func giveSut(event: EventModels.Event) {
        sut = EventDetailsViewModel(coordinator: spyCoordinator,
                                    networkMonitor: mockNetworkMonitor,
                                    event: event,
                                    navigationManager: mockNavigationManager,
                                     getLocalUserUseCase: mockGetLocalUserUseCase,
                                     joinEventUseCase: mockJoinEventUseCase,
                                     leaveEventUseCase: mockLeaveEventUseCase,
                                     getEventAttendeesUseCase: mockGetEventAttendeesUseCase)
    }
}
