//
//  ErrorDialogModelBuilderTests.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 10/10/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite()
final class ErrorDialogModelBuilderTests {

    @Test
    func test_given_get_common_error_model_then_return_correct_data() {

        let model = ErrorDialogModelBuilder.build(type: .commonError)

        #expect(model.animation == nil)
        #expect(model.image == "error_icon")
        #expect(model.primaryText == LocalizationKeys.DefaultError.titleExpanded.localize())
        #expect(model.secondaryText == nil)
        #expect(model.buttonText == LocalizationKeys.Buttons.retry.localize())
    }

    @Test
    func test_given_get_no_internet_model_then_return_correct_data() {

        let model = ErrorDialogModelBuilder.build(type: .noInternet)

        #expect(model.animation == .noConnection)
        #expect(model.image == nil)
        #expect(model.primaryText == LocalizationKeys.NoConnection.title.localize())
        #expect(model.secondaryText == LocalizationKeys.NoConnection.body.localize())
        #expect(model.buttonText == LocalizationKeys.Buttons.ok.localize())
    }
}
