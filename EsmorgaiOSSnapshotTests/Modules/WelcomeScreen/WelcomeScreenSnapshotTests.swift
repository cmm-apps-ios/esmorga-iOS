//
//  WelcomeScreenSnapshotTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 18/10/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class WelcomeScreenSnapshotTests: XCTestCase {

    private var sut: WelcomeScreenView!
    private var viewModel: WelcomeScreenViewModel!

    override func setUpWithError() throws {
        try super.setUpWithError()
        viewModel = WelcomeScreenViewModel(coordinator: nil)
        sut = WelcomeScreenView(viewModel: viewModel)
    }

    override func tearDownWithError() throws {
        sut = nil
        viewModel = nil
        try super.tearDownWithError()
    }

    //MOB-TC-84
    func test_given_welcome_screen_as_initial_state_then_screen_is_correct() throws {
        assertSnapshot(of: sut.toVC(), as: .image)
    }
}
