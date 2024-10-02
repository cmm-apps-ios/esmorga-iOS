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
    private var spyCoordinator: SpyCoordinator!
    private var mockLoginUseCase: MockLoginUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyCoordinator = SpyCoordinator()
        mockLoginUseCase = MockLoginUseCase()
        sut = LoginViewModel(coordinator: spyCoordinator, loginUseCase: mockLoginUseCase)
    }

    override func tearDownWithError() throws {
        spyCoordinator = nil
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
    func test_given_perform_login_when_success_response_then_navigate_to_dashboard() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockUser = UserModels.User(name: "User", lastName: "fake", email: "valid@yopmail.com")

        sut.performLogin()

        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        await expect(self.spyCoordinator.destination).toEventually(equal(.dashboard))
    }

    //MOB-TC-115
    func test_given_perform_login_when_error_server_then_error_dialog_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        sut.performLogin()

        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        await expect(self.spyCoordinator.destination).toEventually(equal(.dialog(ErrorDialogModelBuilder.build(type: .commonError))))
    }

    //MOB-TC-116
    func test_given_perform_login_when_no_connection_then_snackbar_is_shown() async {

        sut.emailTextField.text = "valid@yopmail.com"
        sut.passTextField.text = "SuperSecret!1"

        mockLoginUseCase.mockError = NetworkError.noInternetConnection

        sut.performLogin()

        await expect(self.spyCoordinator.pushCalled).toEventually(beFalse())
        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
        await expect(self.sut.snackBar.message).toEventually(equal(LocalizationKeys.Snackbar.noInternet.localize()))
    }
}
