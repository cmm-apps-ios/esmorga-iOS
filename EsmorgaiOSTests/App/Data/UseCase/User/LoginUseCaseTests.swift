//
//  LoginUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class LoginUseCaseTests: XCTestCase {

    private var sut: LoginUseCase!
    private var mockUserRepository: MockUserRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUserRepository = MockUserRepository()
        sut = LoginUseCase(userRepository: mockUserRepository)
    }

    override func tearDownWithError() throws {
        mockUserRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_user_when_success_response_then_return_user() async {
        let user = UserModels.User(name: "esmorga", lastName: "user", email: "esmorga@yopmail.com")
        mockUserRepository.mockUser = user

        let result = await sut.execute(input: LoginUseCaseInput(email: "esmorga@yopmail.com", password: "Secret1!"))
        switch result {
        case .success(let data):
            expect(data).to(equal(user))
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_get_user_when_failure_response_then_return_error() async {
        let result = await sut.execute(input: LoginUseCaseInput(email: "esmorga@yopmail.com", password: "Secret1!"))
        switch result {
        case .success:
            XCTFail("Unexpected error: Success Result")
        case .failure(let error):
            expect(error).to(matchError(NetworkError.genaralError(code: 500)))
        }
    }
}
