//
//  ConfirmationDialogModelBuilderTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 6/3/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Test
func test_given_get_confirmation_dialog_model_logout_then_return_correct_data() { //El único que hay ahora, el de logout
    
    let model = ConfirmationDialogView.Model()
    
    #expect(model.title == LocalizationKeys.Profile.logoutPopupDescription.localize())
    #expect(model.isShown == true)
    #expect(model.primaryButtonTitle == LocalizationKeys.Profile.logoutPopupConfirm.localize())
    #expect(model.secondaryButtonTitle == LocalizationKeys.Profile.logoutPopupCancel.localize())
    #expect(model.primaryAction == nil)
    #expect(model.secondaryAction == nil)
}
