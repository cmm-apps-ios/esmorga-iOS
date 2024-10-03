//
//  ErrorDialogSnapshotTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/10/24.
//

import XCTest
import SnapshotTesting
@testable import EsmorgaiOS

final class ErrorDialogSnapshotTests: XCTestCase {

    func test_given_no_connection_dialog_then_screen_is_correct() throws {
        let dialog = ErrorDialog(model: ErrorDialogModelBuilder.build(type: .noInternet))
        assertSnapshot(of: dialog.toVC(), as: .image)
    }

    func test_given_common_error_dialog_then_screen_is_correct() throws {
        let dialog = ErrorDialog(model: ErrorDialogModelBuilder.build(type: .commonError))
        assertSnapshot(of: dialog.toVC(), as: .image)
    }
}
