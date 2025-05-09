//
//  RegistrationConfirmViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 6/5/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class RegistrationConfirmViewModelTests {
    private var sut: RegistrationConfirmViewModel!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!


    init() {
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = RegistrationConfirmViewModel(coordinator: spyCoordinator, networkMonitor: mockNetworkMonitor, email: "")
    }

    deinit {
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }

    @MainActor
    @Test
    func test_given_open_email_app_called_then_navigation_is_triggered() async { //Falla

        sut.openMailApp()

        #expect(self.spyCoordinator.openAppCalled == true)

    }

    @MainActor
    @Test
    func test_given_resend_email_called_then_email_is_sent() async {

        sut.resendMail()

        #expect(self.sut.snackBar.isShown == true)
        #expect(self.sut.snackBar.message == LocalizationKeys.Snackbar.resendEmail.localize())

    }

    @MainActor
    @Test
    func test_given_resend_email_fails_then_snackbar_is_shown() async {

        giveSut(email: "yagotest@yopmail.com")
        
        await TestHelper.fullfillTask {
            self.sut.resendMail()
        }

        #expect(self.sut.snackBar.isShown == true)
        #expect(self.sut.snackBar.message == LocalizationKeys.Snackbar.resendEmail.localize())

    }

    private func giveSut(email: String) {
        sut = RegistrationConfirmViewModel(coordinator: spyCoordinator, email: email)
    }
}


