//
//  RegistrationViewTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 11/9/24.
//

import XCTest
import ViewInspector
import SwiftUI
@testable import EsmorgaiOS

final class RegistrationViewTests: XCTestCase {

    private var sut: RegistrationView!
    private var viewModel: RegistrationViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = RegistrationViewModel(coordinator: nil, registerUserUseCase: MockRegisterUserUseCase())
        sut = RegistrationView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        sut = nil
        try super.tearDownWithError()
    }

    //MOB-TC-122
    func test_given_registration_screen_when_initial_state_then_content_is_correct() throws {
        let inspected = try sut.inspect()

        let titleText = try inspected.find(viewWithAccessibilityIdentifier: RegistrationView.AccessibilityIds.title).implicitAnyView()
        XCTAssertEqual(try titleText.text().string(), LocalizationKeys.Registration.title.localize())

        for index in 0..<viewModel.textFields.count {
            let textField = try inspected.find(viewWithAccessibilityIdentifier: "\(RegistrationView.AccessibilityIds.textField)\(index)").implicitAnyView().view(CustomTextField.self).anyView()
            let titleText = try textField.vStack().anyView(0).text() // Assume title is the first text inside VStack
            XCTAssertEqual(try titleText.string(), viewModel.textFields[index].title)
        }

        let button = try inspected.find(viewWithAccessibilityIdentifier: RegistrationView.AccessibilityIds.button).view(CustomButton.self).anyView()
        let buttonText = try button.button().labelView().anyView().text()
        XCTAssertEqual(try buttonText.string(), LocalizationKeys.Buttons.createAccount.localize())
    }
}
