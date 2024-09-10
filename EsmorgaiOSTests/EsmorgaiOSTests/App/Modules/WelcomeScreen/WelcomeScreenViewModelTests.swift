//
//  WelcomeScreenViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class WelcomeScreenViewModelTests: XCTestCase {

    private var sut: WelcomeScreenViewModel!
    private var spyWelcomeScreenRouter: SpyWelcomeScreenRouter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyWelcomeScreenRouter = SpyWelcomeScreenRouter()
        sut = WelcomeScreenViewModel(router: spyWelcomeScreenRouter)
    }

    override func tearDownWithError() throws {
        spyWelcomeScreenRouter = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_loggin_button_tapped_then_navigate_to_login_is_called() {

        sut.loginButtonTapped()

        expect(self.spyWelcomeScreenRouter.navigateToLogginCalled).toEventually(beTrue())
    }

    func test_given_enter_as_guest_button_tapped_then_navigate_to_event_list_is_called() {

        sut.enterAsGuestTapped()

        expect(self.spyWelcomeScreenRouter.navigateToEventListCalled).toEventually(beTrue())
    }
}

final class SpyWelcomeScreenRouter: WelcomeScreenRouterProtocol {

    var navigateToLogginCalled: Bool = false
    var navigateToEventListCalled: Bool = false

    func navigateToLoggin() {
        navigateToLogginCalled = true
    }
    
    func navigateToEventList() {
        navigateToEventListCalled = true
    }
}
