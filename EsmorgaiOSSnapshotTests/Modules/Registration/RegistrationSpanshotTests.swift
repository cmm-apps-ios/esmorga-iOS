//
//  RegistrationSpanshotTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Vidal Pérez, Omar on 11/9/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class RegistrationSpanshotTests: XCTestCase {

    private var sut: RegistrationView!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = RegistrationBuilder().build(mainRouter: Router<MainRoute>(isPresented: .constant(.none)))
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_registration_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_registration_screen_as_when_invalid_fields_then_screen_is_correct_with_inlines() throws {

        sut.viewModel.textFields[0].text = "a"
        sut.viewModel.textFields[1].text = "a"
        sut.viewModel.textFields[2].text = "a"
        sut.viewModel.textFields[3].text = "a"
        sut.viewModel.textFields[4].text = "a"
        sut.viewModel.performRegistration()

        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_registration_screen_as_when_empty_fields_then_screen_is_correct_with_inlines() throws {

        sut.viewModel.performRegistration()
        assertSnapshot(of: sut.toVC(), as: .image)
    }
}
