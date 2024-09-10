//
//  SplashViewTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 6/9/24.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import EsmorgaiOS

final class SplashViewTests: XCTestCase {

    private var sut: SplashView!
    private var viewModel: SplashViewModel!
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        viewModel = SplashViewModel(getLocalUserUseCase: mockGetLocalUserUseCase)
        sut = SplashView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        mockGetLocalUserUseCase = nil
        viewModel = nil
        sut = nil
        try super.tearDownWithError()
    }

    //MOB-TC-109
    func test_given_splash_view_when_loading_thenesmorga_image_is_shown() throws {

        let inspected = try sut.inspect()
        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: SplashView.AccessibilityIds.loading))

        let loadingView = try inspected.find(viewWithAccessibilityIdentifier: SplashView.AccessibilityIds.loading)
        let image = try loadingView.find(ViewType.Image.self)
        XCTAssertEqual(try image.actualImage().name(), "esmorga")
    }

    //MOB-TC-118
    func test_given_splash_view_when_not_logged_user_then_welcome_screen_is_shown() async throws {

        await viewModel.getUserStatus()

        let inspected = try sut.inspect()
        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: SplashView.AccessibilityIds.welcome))
    }

    //MOB-TC-119
    func test_given_splash_view_when_logged_user_then_event_list_screen_is_shown() async throws {

        mockGetLocalUserUseCase.mockUser = UserModelBuilder().build()

        await viewModel.getUserStatus()

        let inspected = try sut.inspect()
        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: SplashView.AccessibilityIds.eventList))
    }
}