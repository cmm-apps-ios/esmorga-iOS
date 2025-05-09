//
//  RegistrationConfirmViewTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 7/5/25.
//

import Foundation

import XCTest
import ViewInspector
import SwiftUI
@testable import EsmorgaiOS

final class RegistrationConfirmViewTests: XCTestCase {

    private var sut: RegistrationConfirmView!
    private var viewModel: RegistrationConfirmViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = RegistrationConfirmViewModel(coordinator: SpyCoordinator(), email: "")
        sut = RegistrationConfirmView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_confirmation_screen_view_when_is_as_initial_state_then_show_view() throws {
        let inspected = try sut.inspect()

        let title = try inspected.find(viewWithAccessibilityIdentifier: RegistrationConfirmView.AccessibilityIds.rowTitle).text().string()
        let subtitle = try inspected.find(viewWithAccessibilityIdentifier: RegistrationConfirmView.AccessibilityIds.rowSubTitle).text().string()

        let button = try inspected.find(viewWithAccessibilityIdentifier: RegistrationConfirmView.AccessibilityIds.rowButton).text().string()
        let button2 = try inspected.find(viewWithAccessibilityIdentifier: RegistrationConfirmView.AccessibilityIds.rowButton2).text().string()

        XCTAssertEqual(title, LocalizationKeys.RegistrationConfirmation.title.localize())
        XCTAssertEqual(subtitle, LocalizationKeys.RegistrationConfirmation.subtitle.localize())

        XCTAssertEqual(button, LocalizationKeys.Buttons.confirmEmail)
        XCTAssertEqual(button2, LocalizationKeys.Buttons.resendEmail)
    }
}
