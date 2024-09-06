//
//  SplashViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class SplashViewModelTests: XCTestCase {

    private var sut: SplashViewModel!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        sut = SplashViewModel(getLocalUserUseCase: mockGetLocalUserUseCase)
    }

    override func tearDownWithError() throws {
        mockGetLocalUserUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }


    //MOB-TC-118
    func test_given_splash_screen_when_user_is_logged_out_then_ui_state_is_set_to_logged_out_state() async {

        expect(self.sut.state).to(equal(SplashViewStates.ready))
        await sut.getUserStatus()
        await expect(self.sut.state).toEventually(equal(SplashViewStates.loggedOut))
    }

    //MOB-TC-119
    func test_given_splash_screen_when_user_is_logged_in_then_ui_state_is_set_to_logged_in_state() async {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        expect(self.sut.state).to(equal(SplashViewStates.ready))
        await sut.getUserStatus()
        await expect(self.sut.state).toEventually(equal(SplashViewStates.loggedIn))
    }
}
