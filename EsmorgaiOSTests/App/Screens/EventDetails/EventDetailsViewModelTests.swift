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
    private var mockNavigationManager: MockNavigationManager!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!

    init() {
        spyCoordinator = SpyCoordinator()
        mockNavigationManager = MockNavigationManager()
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
    }

    deinit {
        spyCoordinator = nil
        mockNavigationManager = nil
        mockGetLocalUserUseCase = nil
        sut = nil
    }

    @Test
    func test_given_open_maps_button_tapped_when_only_one_method_then_open_navigation_is_called() {

        giveSut(event: EventBuilder().with(latitude: 40.4165).with(longitude: -3.70256).build())

        sut.openLocation()

        #expect(self.spyCoordinator.openNavigationAppCalled == true)
    }

    @Test
    func test_given_open_maps_button_tapped_when_more_than_one_method_then_alert_is_shon() {

        mockNavigationManager.methods = [NavigationModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!),
                                         NavigationModels.Method(title: "Google Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

        giveSut(event: EventBuilder().with(latitude: 40.4165).with(longitude: -3.70256).build())

        sut.openLocation()

        #expect(self.sut.showMethodsAlert == true)
    }

    @Test
    func test_given_primary_button_tapped_when_user_not_logged_then_login_destination_is_push() {

        giveSut(event: EventBuilder().build())

        sut.state = .loaded(isLogged: false)

        sut.primaryButtonTapped()

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
        #expect(self.sut.model.primaryButtonText == LocalizationKeys.Buttons.joinEvent.localize())
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
        #expect(self.sut.model.primaryButtonText == LocalizationKeys.Buttons.leaveEvent.localize())
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
        #expect(self.sut.model.primaryButtonText == LocalizationKeys.Buttons.loginToJoin.localize())
    }

    private func giveSut(event: EventModels.Event) {
        sut = EventDetailsViewModel(coordinator: spyCoordinator,
                                    event: event,
                                    navigationManager: mockNavigationManager,
                                    getLocalUserUseCase: mockGetLocalUserUseCase)
    }
}
