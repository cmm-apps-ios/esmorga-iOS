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
        let isValid = sut.validateEmailField(checkIsEmpty: false)
        expect(isValid).to(beTrue())
    }

    //MOB-TC-43
    func test_given_email_text_input_when_invalid_then_return_false() {

        let scenarios: [String] = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@example.com",
                                   "space@domain .com",
                                   "invalidemail",
                                   "user+alias@domain.com",
                                   "invalid@domain,com",
                                   "invalid@domain.c"]
        for scenario in scenarios {
            sut.emailTextField.text = scenario
            let isValid = sut.validateEmailField(checkIsEmpty: false)
            expect(isValid).to(beFalse())
            expect(self.sut.emailTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.email.localize()))
        }
    }

    func test_given_password_text_input_when_valid_then_return_true() {

        sut.passTextField.text = "SuperSecret!1"
        let isValid = sut.validatePassField(checkIsEmpty: false)
        expect(isValid).to(beTrue())
    }

    //MOB-TC-44
    func test_given_password_text_input_when_invalid_then_return_false() {

        let scenarios: [String] = ["12ab@", "@abcdefg", "123abcd"]

        for scenario in scenarios {
            sut.passTextField.text = scenario
            let isValid = sut.validatePassField(checkIsEmpty: false)
            expect(isValid).to(beFalse())
            expect(self.sut.passTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.password.localize()))
        }
    }

    //MOB-TC-45
    func test_given_empty_fields_then_error_inline_is_displayed() async {

        sut.passTextField.text = ""
        sut.emailTextField.text = ""

        sut.performLogin()

        expect(self.sut.passTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        expect(self.sut.emailTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))

    }

//    TODO IN THE FUTURE
//    func test_given_email_and_password_text_input_when_empty_then_return_correct_error_message() {
//
//        sut.validatePassField()
//        sut.validateEmailField()
//
//        expect(self.sut.emailTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
//        expect(self.sut.passTextField.errorMessage).to(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
//    }

    //MOB-TC-114
    //MOB-TC-113
    func test_given_perform_login_when_success_response_then_navigate_to_event_list() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockUser = UserModels.User(name: "User", lastName: "fake", email: "valid@yopmail.com")

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToListCalled).toEventually(beTrue())
    }

    //MOB-TC-115
    func test_given_perform_login_when_error_server_then_error_dialog_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToErrorDialogCalled).toEventually(beTrue())
        await expect(self.spyLoginRouter.errorModel?.message).toEventually(equal(LocalizationKeys.DefaultError.titleExpanded.localize()))
        await expect(self.spyLoginRouter.errorModel?.buttonText).toEventually(equal(LocalizationKeys.Buttons.retry.localize()))

    }

    //MOB-TC-116
    func test_given_perform_login_when_no_connection_then_snackbar_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockError = NetworkError.noInternetConnection

        sut.performLogin()

        await expect(self.spyLoginRouter.navigateToErrorDialogCalled).toEventually(beFalse())
        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
        await expect(self.sut.snackBar.message).toEventually(equal(LocalizationKeys.Snackbar.noInternet.localize()))
    }
}

final class SpyLoginRouter: LoginRouterProtocol {

    var navigateToErrorDialogCalled: Bool = false
    var navigateToListCalled: Bool = false
    var navigateToRegisterCalled: Bool = false
    var errorModel: ErrorDialog.Model?

    func navigateToErrorDialog(model: ErrorDialog.Model) {
        errorModel = model
        navigateToErrorDialogCalled = true
    }
    
    func navigateToList() {
        navigateToListCalled = true
    }

    func navigateToRegister() {
        navigateToRegisterCalled = true
    }
}
