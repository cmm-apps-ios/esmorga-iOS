//
//  RegistrationViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class RegistrationViewModelTests: XCTestCase {

    private var sut: RegistrationViewModel!
    private var spyRouter: SpyRouter!
    private var mockRegisterUserUseCase: MockRegisterUserUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyRouter = SpyRouter()
        mockRegisterUserUseCase = MockRegisterUserUseCase()
        sut = RegistrationViewModel(registerUserUseCase: mockRegisterUserUseCase,
                                    router: spyRouter)
    }

    override func tearDownWithError() throws {
        spyRouter = nil
        mockRegisterUserUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_performa_registration_when_success_response_then_navigate_to_list_events() async {

        mockRegisterUserUseCase.mockUser = UserModels.User(name: "Name", lastName: "LastName", email: "test@yopmail.com")

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.spyRouter.navigateToListCalled).toEventually(beTrue())
    }

    func test_given_performa_registration_when_failure_with_general_error_response_then_navigate_to_error_dialog() async {

        mockRegisterUserUseCase.mockError = .generalError

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.spyRouter.navigateToErrorDialogCalled).toEventually(beTrue())
    }

    func test_given_performa_registration_when_failure_with_no_connection_then_show_snackbar() async {

        mockRegisterUserUseCase.mockError = .noInternetConnection

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
        await expect(self.sut.snackBar.message).toEventually(equal(LocalizationKeys.Snackbar.noInternet.localize()))
    }

    func test_given_performa_registration_when_user_already_register_then_show_inline_error() async {

        mockRegisterUserUseCase.mockError = .userRegister

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.sut.textFields[2].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emailAlreadyUsed.localize()))
    }

    func test_given_validate_textfields_when_empty_values_then_show_correct_inline_errors() async {

        sut.performRegistration()
        await expect(self.sut.textFields[0].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[1].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[2].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[3].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[4].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
    }

    func test_given_validate_textfields_when_invalid_values_then_show_correct_inline_errors() async {

        givenTextfieldsInvalid()

        sut.performRegistration()
        await expect(self.sut.textFields[0].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.name.localize()))
        await expect(self.sut.textFields[1].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.lastName.localize()))
        await expect(self.sut.textFields[2].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.email.localize()))
        await expect(self.sut.textFields[3].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.password.localize()))
        await expect(self.sut.textFields[4].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.passwordMismatch.localize()))
    }

    private func givenTextfieldsValid() {
        sut.textFields[0].text = "Name"
        sut.textFields[1].text = "LastName"
        sut.textFields[2].text = "test@yopmail.com"
        sut.textFields[3].text = "SuperSecret1!"
        sut.textFields[4].text = "SuperSecret1!"
    }

    private func givenTextfieldsInvalid() {
        sut.textFields[0].text = "1"
        sut.textFields[1].text = "2"
        sut.textFields[2].text = "test@"
        sut.textFields[3].text = "Super"
        sut.textFields[4].text = "SuperSecre"
    }
}

class SpyRouter: RegistrationRouterProtocol {

    var navigateToErrorDialogCalled: Bool = false
    var navigateToListCalled: Bool = false
    var navigateToRegisterCalled: Bool = false

    func navigateToErrorDialog(model: ErrorDialog.Model) {
        navigateToErrorDialogCalled = true
    }

    func navigateToList() {
        navigateToListCalled = true
    }
}
