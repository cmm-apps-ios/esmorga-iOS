//
//  EsmorgaiOSSnapshotTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Vidal Pérez, Omar on 10/9/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class LoginSnapshotTests: XCTestCase {

    private var sut: LoginView!
    private var viewModel: LoginViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = LoginViewModel(coordinator: nil)
        sut = LoginView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func test_given_login_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_login_screen_as_when_invalid_fields_then_screen_is_correct_with_inlines() throws {

        viewModel.emailTextField.text = "123"
        viewModel.passTextField.text = "test"
        viewModel.validateEmailField(checkIsEmpty: false)
        viewModel.validatePassField(checkIsEmpty: false)

        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_login_screen_as_when_empty_fields_then_screen_is_correct_with_inlines() throws {

        viewModel.performLogin()
        assertSnapshot(of: sut.toVC(), as: .image)
    }
}
