//
//  RegisterUserUseCaseTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class RegisterUserUseCaseTests: XCTestCase {

    private var sut: RegisterUserUseCase!
    private var mockUserRepository: MockUserRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUserRepository = MockUserRepository()
        sut = RegisterUserUseCase(userRepository: mockUserRepository)
    }

    override func tearDownWithError() throws {
        mockUserRepository = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_get_user_when_success_response_then_return_user() async {

        let user = UserModels.User(name: "esmorga", lastName: "user", email: "esmorga@yopmail.com")
        mockUserRepository.mockUser = user

        let result = await sut.execute(input: givenInput())
        switch result {
        case .success(let data):
            expect(data).to(equal(user))
        case .failure(let error):
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_given_get_user_when_failure_response_then_return_error() async {

        let scenarios: [(error: NetworkError, expected: RegisterUserError)] = [(.noInternetConnection, .noInternetConnection),
                                                                               (.mappingError, .mappingError),
                                                                               (.generalError(code: 500), .generalError),
                                                                               (.generalError(code: 409), .userRegister)]

        for scenario in scenarios {
            mockUserRepository.mockError = scenario.error

            let result = await sut.execute(input: givenInput())
            switch result {
            case .success:
                XCTFail("Unexpected error: Success Result")
            case .failure(let error):
                expect(error).to(matchError(scenario.expected))
            }
        }
    }

    private func givenInput() -> RegisterUserUseCaseInput {
        return RegisterUserUseCaseInput(name: "name",
                                        lastName: "lastName",
                                        email: "test@yopmail.com",
                                        password: "SuperSecret!1")
    }
}
