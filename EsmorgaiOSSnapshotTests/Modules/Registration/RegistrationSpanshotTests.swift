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
    private var viewModel: RegistrationViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = RegistrationViewModel(coordinator: nil)
        sut = RegistrationView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func test_given_registration_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_registration_screen_as_when_invalid_fields_then_screen_is_correct_with_inlines() throws {

        viewModel.textFields[0].text = "a"
        viewModel.textFields[1].text = "a"
        viewModel.textFields[2].text = "a"
        viewModel.textFields[3].text = "a"
        viewModel.textFields[4].text = "a"
        viewModel.performRegistration()

        assertSnapshot(of: sut.toVC(), as: .image)
    }

    func test_given_registration_screen_as_when_empty_fields_then_screen_is_correct_with_inlines() throws {

        viewModel.performRegistration()
        assertSnapshot(of: sut.toVC(), as: .image)
    }
}
