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
    private var mockLoginUserDataSource: MockLoginUserDataSource!
    private var mockRegisterUserDataSource: MockRegisterUserDataSource!
    private var mockLocalUserDataSource: MockLocalUserDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockLoginUserDataSource = MockLoginUserDataSource()
        mockRegisterUserDataSource = MockRegisterUserDataSource()
        mockLocalUserDataSource = MockLocalUserDataSource()
        sut = UserRepository(localUserDataSource: mockLocalUserDataSource,
                             loginUserDataSource: mockLoginUserDataSource,
                             registerUserDataSource: mockRegisterUserDataSource)
    }

    override func tearDownWithError() throws {
        mockLoginUserDataSource = nil
        mockRegisterUserDataSource = nil
        mockLocalUserDataSource = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_login_user_when_success_response_then_return_user_data() async {

        let remoteUser = LoginModelBuilder().build()
        mockLoginUserDataSource.mockLogin = remoteUser

        let result = try? await sut.login(email: "email@yopmail.com", password: "Secret1!")

        expect(result?.email).to(equal(remoteUser.profile.email))
        expect(result?.name).to(equal(remoteUser.profile.name))
        expect(result?.lastName).to(equal(remoteUser.profile.lastName))
        expect(self.mockLocalUserDataSource.savedUser).to(equal(result))
    }

    func test_login_user_when_failure_response_then_return_error() async {

        do {
            _ = try await sut.login(email: "email@yopmail.com", password: "Secret1!")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    func test_register_user_when_success_response_then_return_user_data() async {

        let remoteUser = LoginModelBuilder().build()
        mockRegisterUserDataSource.mockLogin = remoteUser

        let result = try? await sut.register(name: "name", lastName: "lastName", pass: "SuperSecret!1", email: "name@yopmail.com")

        expect(result?.email).to(equal(remoteUser.profile.email))
        expect(result?.name).to(equal(remoteUser.profile.name))
        expect(result?.lastName).to(equal(remoteUser.profile.lastName))
        expect(self.mockLocalUserDataSource.savedUser).to(equal(result))
    }

    func test_register_user_when_failure_response_then_return_error() async {

        do {
            _ = try await sut.register(name: "name", lastName: "lastName", pass: "SuperSecret!1", email: "name@yopmail.com")
            XCTFail("Expected error to be thrown")
        } catch {
            expect(error).to(matchError(NetworkError.generalError(code: 500)))
        }
    }

    func test_given_local_user_when_no_data_then_return_nil() async {

        let result = await sut.getLocalUser()

        expect(result).to(beNil())
    }

    func test_given_local_user_when_data_in_cache_then_return_user() async {

        let user = UserModelBuilder().build()
        mockLocalUserDataSource.savedUser = user

        let result = await sut.getLocalUser()

        expect(result).to(equal(user))
    }
}


