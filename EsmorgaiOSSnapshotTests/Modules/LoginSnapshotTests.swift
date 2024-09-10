//
//  LoginSnapshotTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Vidal Pérez, Omar on 9/9/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class LoginSnapshotTests: XCTestCase {

    private var sut: LoginView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LoginBuilder().build(mainRouter: Router<MainRoute>(isPresented: .constant(.none)))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_login_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_login_screen_as_when_invalid_fields_then_screen_is_correct_with_inlines() throws {

        sut.viewModel.emailTextField.text = "123"
        sut.viewModel.passTextField.text = "test"
        sut.viewModel.validateEmailField(checkIsEmpty: false)
        sut.viewModel.validatePassField(checkIsEmpty: false)

        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_login_screen_as_when_empty_fields_then_screen_is_correct_with_inlines() throws {

        sut.viewModel.performLogin()
        assertSnapshot(of: sut.toVC(), as: .image)
    }
}
