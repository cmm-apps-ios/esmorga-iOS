//
//  UserRepositoryTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class UserRepositoryTests {
    
    private var sut: UserRepository!
    private var mockLoginUserDataSource: MockLoginUserDataSource!
    private var mockRegisterUserDataSource: MockRegisterUserDataSource!
    private var mockLocalUserDataSource: MockLocalUserDataSource!
    private var mockLocalEventsDataSource: MockLocalEventsDataSource!
    private var sessionKeychain: CodableKeychain<AccountSession>!
    
    init() {
        mockLoginUserDataSource = MockLoginUserDataSource()
        mockRegisterUserDataSource = MockRegisterUserDataSource()
        mockLocalUserDataSource = MockLocalUserDataSource()
        mockLocalEventsDataSource = MockLocalEventsDataSource()
        sessionKeychain = AccountSession.buildCodableKeychain()
        try? sessionKeychain.delete()
        sut = UserRepository(localUserDataSource: mockLocalUserDataSource,
                             loginUserDataSource: mockLoginUserDataSource,
                             registerUserDataSource: mockRegisterUserDataSource,
                             localEventsDataSource: mockLocalEventsDataSource,
                             sessionKeychain: sessionKeychain)
    }
    
    deinit {
        try? sessionKeychain.delete()
        sessionKeychain = nil
        mockLoginUserDataSource = nil
        mockRegisterUserDataSource = nil
        mockLocalUserDataSource = nil
        mockLocalEventsDataSource = nil
        sut = nil
    }
    
    @Test
    func test_login_user_when_success_response_then_return_user_data() async {
        
        let remoteUser = LoginModelBuilder().build()
        mockLoginUserDataSource.mockLogin = remoteUser
        
        let result = try? await sut.login(email: "email@yopmail.com", password: "Secret1!")
        
        #expect(result?.email == remoteUser.profile.email)
        #expect(result?.name == remoteUser.profile.name)
        #expect(result?.lastName == remoteUser.profile.lastName)
        #expect(self.mockLocalUserDataSource.savedUser == result)
        #expect(self.sessionKeychain.isLogged)
        #expect(self.mockLocalEventsDataSource.clearAllCalled)
    }
    
    @Test
    func test_login_user_when_failure_response_then_return_error() async {
        
        do {
            _ = try await sut.login(email: "email@yopmail.com", password: "Secret1!")
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
    
    @Test
    func test_register_user_when_success_response_then_return_user_data() async {
        
        let remoteUser = LoginModelBuilder().build()
        mockRegisterUserDataSource.mockLogin = remoteUser
        
        let result = try? await sut.register(name: "name", lastName: "lastName", pass: "SuperSecret!1", email: "name@yopmail.com")
        
        #expect(result?.email == remoteUser.profile.email)
        #expect(result?.name == remoteUser.profile.name)
        #expect(result?.lastName == remoteUser.profile.lastName)
        #expect(self.mockLocalUserDataSource.savedUser == result)
        #expect(self.sessionKeychain.isLogged)
        #expect(self.mockLocalEventsDataSource.clearAllCalled)
    }
    
    @Test
    func test_register_user_when_failure_response_then_return_error() async {
        
        do {
            _ = try await sut.register(name: "name", lastName: "lastName", pass: "SuperSecret!1", email: "name@yopmail.com")
            Issue.record("Expected error to be thrown")
        } catch {
            let expectedError = error as? NetworkError
            #expect(expectedError == NetworkError.generalError(code: 500))
        }
    }
    
    @Test
    func test_given_local_user_when_no_data_then_return_nil() async {
        
        let result = await sut.getLocalUser()
        
        #expect(result == nil)
    }
    
    @Test
    func test_given_local_user_when_data_in_cache_then_return_user() async {
        
        let user = UserModelBuilder().build()
        mockLocalUserDataSource.savedUser = user
        
        let result = await sut.getLocalUser()
        
        #expect(result == user)
    }
    
    @Test
    func test_local_user_when_logout_then_data_is_clear() async {
        let user = UserModelBuilder().build()
        mockLocalUserDataSource.savedUser = user
        _ = try? await sut.login(email: "email@yopmail.com", password: "Secret1!")
        
        let result = await sut.logoutUser()
        
        #expect(result == true)
        #expect(self.mockLocalUserDataSource.savedUser == nil)
        #expect(self.sessionKeychain.isLogged == false)
    }
    
    @Test
    func test_local_user_clear_then_all_local_user_data() {
        let user = UserModelBuilder().build()
        mockLocalUserDataSource.savedUser = user
        mockLocalUserDataSource.clearAll()
        
        #expect(self.mockLocalUserDataSource.savedUser == nil)
    }
}


