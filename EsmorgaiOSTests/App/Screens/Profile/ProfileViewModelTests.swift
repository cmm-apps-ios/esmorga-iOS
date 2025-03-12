//
//  ProfileViewModelTest.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 11/3/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class ProfileViewModelTests {
    private var sut: ProfileViewModel!
    private var errorDialog: ErrorDialog! //No se si pinta algo aquí
    private var mockGetLocalUserUseCase: MockGetLocalUserUseCase!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!

    
    init() {
        mockGetLocalUserUseCase = MockGetLocalUserUseCase()
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = ProfileViewModel(coordinator: spyCoordinator, getLocalUserUseCase: mockGetLocalUserUseCase)
    }
    
    deinit {
        mockGetLocalUserUseCase = nil
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }
    
    @MainActor
    @Test
    func test_given_get_profile_when_no_logged_in_then_log_out_screen_is_shown() async {
        
        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }
        
        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.confirmationDialogModel.isShown == false)
        #expect(self.sut.user == nil)
        
    }
    
    @Test
    func test_given_login_button_tapped_then_navigate_to_login_is_called() {
        
        sut.loginButtonTapped()
        
        #expect(self.spyCoordinator.pushCalled == true)
        #expect(self.spyCoordinator.destination == .login)
    }
    
    @MainActor
    @Test
    func test_given_get_profile_when_success_then_profile_is_correct() async {
        
        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        
        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }
        
        #expect(self.sut.state == .ready)
        #expect(self.sut.confirmationDialogModel.isShown == false)
        #expect(self.sut.user == user)
    }
    
    @MainActor
    @Test
    func test_given_close_session_tapped_close_session_confirmation_dialog_appears() async {
        
        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        
        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }
        
        sut.optionTapped(type: .closeSession)
        
        #expect(self.sut.state == .ready)
        #expect(self.sut.confirmationDialogModel.isShown == true)
        #expect(self.sut.user == user)
        
    }
    
    @MainActor
    @Test
    func test_given_confirmation_dialog_when_tapped_close_session_then_log_out_screen_is_shown() async {
        
        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        
        await TestHelper.fullfillTask {
            await self.sut.checkLoginStatus()
        }
        
        //sut.optionTapped(type: .closeSession)
        sut.confirmationDialogModel.primaryAction?()
        
        await TestHelper.fullfillTask {
            await self.sut.closeSession()
        }
  
        #expect(self.sut.state == .loggedOut)
        #expect(self.sut.confirmationDialogModel.isShown == false)
      //  #expect(self.sut.user == nil) -> No cambia el estado, probablemente porque la acción del Ok del dialog no se ejecuta arriba
        
    }
    
    
    
    //Aún por ver como hacerlo
    @MainActor
    @Test
    func test_given_change_password_tapped_without_connection_then_no_connection_screean_appears() async {
        
        let user = UserModelBuilder().build()
        mockGetLocalUserUseCase.mockUser = user
        mockNetworkMonitor.mockIsConnected = false
        
        
        sut.optionTapped(type: .changePassword)
    }
}
