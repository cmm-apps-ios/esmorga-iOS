//
//  ActivateViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 26/5/25.
//

import Foundation
import Nimble
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class ActivateAccountViewModelTests {
    private var sut: ActivateAccountViewModel
    private var spyCoordinator: SpyCoordinator!

    private var mockActivateUserUseCase: MockActivateUserUseCase!


    init() {
        spyCoordinator = SpyCoordinator()
        mockActivateUserUseCase = MockActivateUserUseCase()
        sut = ActivateAccountViewModel(coordinator: spyCoordinator, activateUserUseCase: mockActivateUserUseCase, code: "12345")
    }

    deinit {
        spyCoordinator = nil
        mockActivateUserUseCase = nil
    }


    @Test
    func test_given_perform_activate_tapped_then_navigation_is_triggered() async {
        mockActivateUserUseCase.mockUser = UserModels.User(name: "Name", lastName: "LastName", email: "test@yopmail.com", role: .user)
        sut.activateUser()
        await expect(self.sut.activationResult).toEventually(equal(.success))
        sut.continueAction()
        expect(self.spyCoordinator.pushCalled).to(beTrue())
        expect(self.spyCoordinator.destination).to(equal(.dashboard))
    }

    @Test
    func test_given_perform_activate_when_failure_with_error_code_response_then_navigate_to_error_dialog() async {
        mockActivateUserUseCase.mockError = .generalError
        sut.activateUser()
        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())
        await expect(self.spyCoordinator.destination).toEventually(equal(.dialog(ErrorDialogModelBuilder.build(type: .expiredCode))))
    }

    @Test
    func test_given_perform_activate_when_failure_with_general_error_response_then_navigate_to_error_dialog() async {
        mockActivateUserUseCase.mockError = .generalError

        sut.activateUser()
        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())

        spyCoordinator.pushCalled = false
        sut.activateUser()
        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())

        spyCoordinator.pushCalled = false
        sut.activateUser()
        await expect(self.spyCoordinator.pushCalled).toEventually(beTrue())

        expect(self.spyCoordinator.destination).to(equal(.dialog(ErrorDialogModelBuilder.build(type: .commonError2))))
    }
}



