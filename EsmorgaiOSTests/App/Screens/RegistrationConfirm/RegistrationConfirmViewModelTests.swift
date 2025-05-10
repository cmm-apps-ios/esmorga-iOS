//
//  RegistrationConfirmViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 6/5/25.
//

import Foundation
import Nimble
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class RegistrationConfirmViewModelTests {
    private var sut: RegistrationConfirmViewModel!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var mockMailManager: MockExternalAppsManager!
    private var mockVerifyUserUseCase: MockVerifyUserUseCase!


    init() {
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        mockMailManager = MockExternalAppsManager()
        mockVerifyUserUseCase = MockVerifyUserUseCase()
        sut = RegistrationConfirmViewModel(coordinator: spyCoordinator, networkMonitor: mockNetworkMonitor, verifyUserUseCase: mockVerifyUserUseCase, email: "esmorgatest@yopmail.com")
    }

    deinit {
        spyCoordinator = nil
        mockMailManager = nil
        mockNetworkMonitor = nil
        mockVerifyUserUseCase = nil
        sut = nil
    }


    @Test
    func test_given_open_email_tapped_then_navigation_is_triggered() async {

        sut.openMailApp()

        #expect(self.sut.primaryButton.title == LocalizationKeys.Buttons.confirmEmail.localize())
        #expect(self.sut.showMethodsAlert == true)
    }

    @Test
    func test_given_open_email_button_tapped_when_more_than_one_method_then_alert_is_shown() {


        mockMailManager.methods2 = [DeepLinkModels.Method(title: "Gmail", url: URL(string: "googlegmail://co?to=&subject=Subject&body=Body")!),
                                    DeepLinkModels.Method(title: "OutLookMail", url: URL(string: "ms-outlook://")!)]

        sut.openMailApp()

        #expect(self.sut.primaryButton.title == LocalizationKeys.Buttons.confirmEmail.localize())
        #expect(self.sut.showMethodsAlert == true)
    }

    @Test
    func test_given_resend_eamil_button_tapped_then_email_is_sent() async{

        mockVerifyUserUseCase.mockResult = .init(true)

        sut.resendMail()

        #expect(self.sut.secondaryButton.title == LocalizationKeys.Buttons.resendEmail.localize())
        await expect(self.sut.snackBar.isShown).toEventually(beTrue())

    }

    @Test
    func test_given_resend_eamil_button_tapped_without_internet_connection_snackbar_is_shown() async{

        mockVerifyUserUseCase.mockError = .noInternetConnection

        sut.resendMail()

        #expect(self.sut.secondaryButton.title == LocalizationKeys.Buttons.resendEmail.localize())
        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
    }
}


