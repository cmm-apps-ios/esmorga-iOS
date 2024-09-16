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
    private var spyCoordinator: SpyCoordinator!
    private var mockRegisterUserUseCase: MockRegisterUserUseCase!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyCoordinator = SpyCoordinator()
        mockRegisterUserUseCase = MockRegisterUserUseCase()
        sut = RegistrationViewModel(coordinator: spyCoordinator,
                                    registerUserUseCase: mockRegisterUserUseCase)
    }

    override func tearDownWithError() throws {
        spyCoordinator = nil
        mockRegisterUserUseCase = nil
        sut = nil
        try super.tearDownWithError()
    }

    //MOB-TC-129
    func test_given_performa_registration_when_success_response_then_navigate_to_dashboard() async {

        mockRegisterUserUseCase.mockUser = UserModels.User(name: "Name", lastName: "LastName", email: "test@yopmail.com")

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        await expect(self.spyCoordinator.destination).toEventually(equal(.dashboard))
    }

    //MOB-TC-131
    func test_given_performa_registration_when_failure_with_general_error_response_then_navigate_to_error_dialog() async {

        mockRegisterUserUseCase.mockError = .generalError

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        await expect(self.spyCoordinator.destination).toEventually(equal(.dialog(.init(image: "error_icon",
                                                                                       message: LocalizationKeys.DefaultError.titleExpanded.localize(),
                                                                                       buttonText: LocalizationKeys.Buttons.retry.localize(),
                                                                                       handler: nil))))
    }

    //MOB-TC-132
    func test_given_performa_registration_when_failure_with_no_connection_then_show_snackbar() async {

        mockRegisterUserUseCase.mockError = .noInternetConnection

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.sut.snackBar.isShown).toEventually(beTrue())
        await expect(self.sut.snackBar.message).toEventually(equal(LocalizationKeys.Snackbar.noInternet.localize()))
    }

    //MOB-TC-123
    func test_given_email_input_when_format_is_invalid_then_show_inline_error_message() async {

        let scenarios: [String] = ["aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa@example.com",
                                   "space@domain .com",
                                   "invalidemail",
                                   "user+alias@domain.com",
                                   "invalid@domain,com",
                                   "invalid@domain.c"]

        for scenario in scenarios {
            sut.textFields[RegisterModels.TextFieldType.email.rawValue].text = scenario
            sut.validateTextField(type: .email, checkIsEmpty: false)
            await expect(self.sut.textFields[RegisterModels.TextFieldType.email.rawValue].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.email.localize()))
        }
    }

    //MOB-TC-124
    func test_given_pass_input_when_format_is_invalid_then_show_inline_error_message() async {
        let scenarios: [String] = ["12ab@", "@abcdefg", "123abcd"]

        for scenario in scenarios {
            sut.textFields[RegisterModels.TextFieldType.pass.rawValue].text = scenario
            sut.validateTextField(type: .pass, checkIsEmpty: false)
            await expect(self.sut.textFields[RegisterModels.TextFieldType.pass.rawValue].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.password.localize()))
        }
    }

    //MOB-TC-127
    func test_given_name_input_when_format_is_invalid_then_show_inline_error_message() async {
        let scenarios: [String] = ["a", "user!!!"]

        for scenario in scenarios {
            sut.textFields[RegisterModels.TextFieldType.name.rawValue].text = scenario
            sut.validateTextField(type: .name, checkIsEmpty: false)
            await expect(self.sut.textFields[RegisterModels.TextFieldType.name.rawValue].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.name.localize()))
        }
    }

    //MOB-TC-136
    func test_given_lastName_input_when_format_is_invalid_then_show_inline_error_message() async {
        let scenarios: [String] = ["a", "user!!!"]

        for scenario in scenarios {
            sut.textFields[RegisterModels.TextFieldType.lastName.rawValue].text = scenario
            sut.validateTextField(type: .lastName, checkIsEmpty: false)
            await expect(self.sut.textFields[RegisterModels.TextFieldType.lastName.rawValue].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.lastName.localize()))
        }
    }

    func test_given_performa_registration_when_user_already_register_then_show_inline_error() async {

        mockRegisterUserUseCase.mockError = .userRegister

        givenTextfieldsValid()
        sut.performRegistration()

        await expect(self.sut.textFields[2].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emailAlreadyUsed.localize()))
    }

    //MOB-TC-128
    func test_given_validate_textfields_when_empty_values_then_show_correct_inline_errors() async {

        sut.performRegistration()
        await expect(self.sut.textFields[0].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[1].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[2].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[3].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
        await expect(self.sut.textFields[4].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.emptyField.localize()))
    }

    //MOB-TC-130
    func test_given_confirm_pass_input_when_is_different_from_pass_then_show_correct_error_inline() async {

        sut.textFields[RegisterModels.TextFieldType.pass.rawValue].text = "Password01!"
        sut.textFields[RegisterModels.TextFieldType.confirmPass.rawValue].text = "Password02!"
        sut.validateTextField(type: .confirmPass, checkIsEmpty: false)

        await expect(self.sut.textFields[4].errorMessage).toEventually(equal(LocalizationKeys.TextField.InlineError.passwordMismatch.localize()))
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
