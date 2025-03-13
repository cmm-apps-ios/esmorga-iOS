//
//  ProfileViewModelTest.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 11/3/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class ProfileViewModelTests {
    private var sut: ProfileViewModel!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!


    init() {
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = ProfileViewModel(coordinator: spyCoordinator, networkMonitor: mockNetworkMonitor, getLocalUserUseCase: mockGetLocalUserUseCase)
    }

    deinit {
        mockGetLocalUserUseCase = nil
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }

    //MOB-TC-160
    @MainActor
    @Test
    func test_given_profile_when_no_logged_in_then_log_out_screen_is_shown() async {

        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }

        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.confirmationDialog.isShown == false)
        #expect(self.sut.user == nil)

    }

    @Test
    func test_given_login_button_tapped_then_navigate_to_login_is_called() {

        sut.loginButtonTapped()

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .login)
    }

    @MainActor
    @Test
    func test_given_profile_when_success_then_profile_is_correct() async {

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user

        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }

        #expect(self.sut.state == .ready)
        #expect(self.sut.confirmationDialog.isShown == false)
        #expect(self.sut.user == user)
    }

    @MainActor
    @Test
    func test_given_button_close_session_tapped_confirmation_dialog_appears() async {

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user

        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }

        sut.optionTapped(type: .closeSession)

        #expect(self.sut.state == .ready)
        #expect(self.sut.confirmationDialog.isShown == true)
        #expect(self.sut.user == user)

    }

    //MOB-TC-159
    @MainActor
    @Test
    func test_given_confirmation_dialog_when_tapped_confirm_then_log_out_screen_is_shown() async {

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user

        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }

        sut.confirmationDialog.primaryAction?()

        await TestHelper.fullfillTask {
            await self.sut.closeSession()
        }

        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.confirmationDialog.isShown == false)
        #expect(self.sut.user == nil)
    }

    @MainActor
    @Test
    func test_given_confirmation_dialog_when_tapped_cancel_then_dialog_dimiss() async {

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user

        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }

        sut.confirmationDialog.secondaryAction?()

        #expect(self.sut.state == .ready)
        #expect(self.sut.confirmationDialog.isShown == false)
        #expect(self.sut.user == user)
    }


    //MOB-TC-162
    @MainActor
    @Test
    func test_given_change_password_tapped_without_connection_then_no_connection_screean_appears() async {

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        mockNetworkMonitor.mockIsConnected = false

        sut.optionTapped(type: .changePassword)

        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .dialog(ErrorDialogModelBuilder.build(type: .noInternet)))
    }

    @MainActor
    @Test
    func test_given_change_password_tapped_then_change_password_screen_appears() async { //Screen doesn't exist, placeholder for now.

        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        mockNetworkMonitor.mockIsConnected = true

        sut.optionTapped(type: .changePassword)

        //   #expect(self.spyCoordinator.pushCalled == true)
        //...
    }
}
