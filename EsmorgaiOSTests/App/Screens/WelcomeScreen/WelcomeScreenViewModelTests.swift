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
    private var spyCoordinator: SpyCoordinator!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyCoordinator = SpyCoordinator()
        sut = WelcomeScreenViewModel(coordinator: spyCoordinator)
    }

    override func tearDownWithError() throws {
        spyCoordinator = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_loggin_button_tapped_then_navigate_to_login_is_called() {

        sut.loginButtonTapped()

        expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        expect(self.spyCoordinator.destination).toEventually(equal(.login))    }

    //MOB-TC-85
    func test_given_enter_as_guest_button_tapped_then_navigate_to_dashboard_is_called() {

        sut.enterAsGuestTapped()

        expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        expect(self.spyCoordinator.destination).toEventually(equal(.dashboard))
    }
}
