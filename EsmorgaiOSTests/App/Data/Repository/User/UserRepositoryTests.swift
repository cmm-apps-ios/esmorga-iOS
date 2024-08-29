//
//  UserRepositoryTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class UserRepositoryTests: XCTestCase {

    private var sut: UserRepository!
    private var mockUserRemoteDataSource: MockUserRemoteDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockUserRemoteDataSource = MockUserRemoteDataSource()
        sut = UserRepository(remoteDataSource: mockUserRemoteDataSource)
    }

    override func tearDownWithError() throws {
        mockUserRemoteDataSource = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_login_user_when_success_response_then_return_user_data() async {

        let remoteUser = LoginModelBuilder().build()
        mockUserRemoteDataSource.mockLogin = remoteUser

        let result = try? await sut.login(email: "email@yopmail.com", password: "Secret1!")

        expect(result?.email).to(equal(remoteUser.profile.email))
        expect(result?.name).to(equal(remoteUser.profile.name))
        expect(result?.lastName).to(equal(remoteUser.profile.lastName))
    }

    func test_login_user_when_failure_response_then_return_error() async {

        do {
            _ = try await sut.login(email: "email@yopmail.com", password: "Secret1!")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.genaralError(code: 500)))
        }
    }
}


