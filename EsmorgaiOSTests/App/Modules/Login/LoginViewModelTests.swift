//
//  LoginViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class LoginViewModelTests: XCTestCase {

    private var sut: LoginViewModel!
    private var spyLoginRouter: SpyLoginRouter!
    private var mockLoginUseCase: MockLoginUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyLoginRouter = SpyLoginRouter()
        mockLoginUseCase = MockLoginUseCase()
        sut = LoginViewModel(loginUseCase: mockLoginUseCase, router: spyLoginRouter)
    }

    override func tearDownWithError() throws {
        spyLoginRouter = nil
        mockLoginUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_email_text_input_when_valid_then_return_true() {

        sut.emailTextField.text = "valid@yopmail.com"
        let isValid = sut.validateEmail()
        expect(isValid).to(beTrue())
    }

    func test_given_email_text_input_when_invalid_then_return_false() {

        sut.emailTextField.text = "invalid.com"
        let isValid = sut.validateEmail()
        expect(isValid).to(beFalse())
        expect(self.sut.emailTextField.errorMessage).to(equal(Localize.localize(key: LocalizationKeys.Login.invalidEmailText)))
    }

    func test_given_password_text_input_when_valid_then_return_true() {

        sut.passTextField.text = "SuperSecret!1"
        let isValid = sut.validatePass()
        expect(isValid).to(beTrue())
    }

    func test_given_password_text_input_when_invalid_then_return_false() {

        sut.passTextField.text = "invalid.com"
        let isValid = sut.validatePass()
        expect(isValid).to(beFalse())
        expect(self.sut.passTextField.errorMessage).to(equal(Localize.localize(key: LocalizationKeys.Login.invalidPasswordText)))
    }

    func test_given_email_and_password_text_input_when_emptu_then_return_correct_error_message() {

        sut.validatePass()
        sut.validateEmail()

        expect(self.sut.emailTextField.errorMessage).to(equal(Localize.localize(key: LocalizationKeys.Login.emptyTextField)))
        expect(self.sut.passTextField.errorMessage).to(equal(Localize.localize(key: LocalizationKeys.Login.emptyTextField)))
    }

    func test_given_perform_login_when_error_server_then_error_dialog_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToErrorDialogCalled).toEventually(beTrue())
    }

    func test_given_perform_login_when_no_connection_then_snackbar_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockError = NetworkError.noInternetConnection

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToErrorDialogCalled).toEventually(beFalse())
        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
        await expect(self.sut.snackBar.message).toEventually(equal(Localize.localize(key: LocalizationKeys.CommonKeys.noConnectionText)))
    }

    func test_given_perform_login_when_success_response_then_navigate_to_event_list() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockUser = UserModels.User(name: "User", lastName: "fake", email: "valid@yopmail.com")

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToListCalled).toEventually(beTrue())
    }
}

final class SpyLoginRouter: LoginRouterProtocol {

    var navigateToErrorDialogCalled: Bool = false
    var navigateToListCalled: Bool = false

    func navigateToErrorDialog(model: ErrorDialog.Model) {
        navigateToErrorDialogCalled = true
    }
    
    func navigateToList() {
        navigateToListCalled = true
    }
}
