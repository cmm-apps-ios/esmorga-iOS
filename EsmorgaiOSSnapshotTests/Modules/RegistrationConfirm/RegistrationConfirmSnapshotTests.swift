//
//  RegistrationConfirmSnapshotTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Ares Armesto, Yago on 8/5/25.
//


import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class RegistrationConfirmScreenSnapshotTests: XCTestCase {

    private var sut:  RegistrationConfirmView!
    private var viewModel: RegistrationConfirmViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel =  RegistrationConfirmViewModel(coordinator: nil, email: "")
        sut =  RegistrationConfirmView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    func test_regsitration_confirm_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image(precision: 0.98))
    }
}
