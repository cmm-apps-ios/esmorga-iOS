//
//  ProfileViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

enum ProfileViewStates: ViewStateProtocol {
    case ready
    case loggedOut
}

class ProfileViewModel: BaseViewModel<ProfileViewStates> {
    

    private let getLocalUserUseCase: GetLocalUserUseCaseAlias

    private let logoutUserUseCase: LogoutUserUseCaseAlias

    private let mapper: ProfileViewModelMapper
   
    var user: UserModels.User?
    
 
    @Published var loggedModel: ProfileModels.LoggedModel?
   
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    @Published var confirmationDialogModel = ConfirmationDialogView.Model(title: LocalizationKeys.Profile.logoutPopupDescription.localize(),
                                                                          isShown: false,
                                                                          primaryButtonTitle: LocalizationKeys.Profile.logoutPopupConfirm.localize(),
                                                                          secondaryButtonTitle: LocalizationKeys.Profile.logoutPopupCancel.localize(),
                                                                          primaryAction: nil,
                                                                          secondaryAction: nil)
    
  
    init(coordinator: (any CoordinatorProtocol)? = nil,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         logoutUserUseCase: LogoutUserUseCaseAlias = LogoutUserUseCase(),
         mapper: ProfileViewModelMapper = ProfileViewModelMapper()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.mapper = mapper
        super.init(coordinator: coordinator)
       
        
        self.confirmationDialogModel.primaryAction = {
            Task {
                await self.closeSession()
            }
        }
         
    }
    
  
    @MainActor
    func checkLoginStatus() async {
        let isUserLogged = await getLocalUserUseCase.execute()
        switch isUserLogged {
        case .success(let user): 
            self.user = user
            self.loggedModel = mapper.map(user: user)
            changeState(.ready)
        case .failure:
            changeState(.loggedOut)
        }
    }
    
    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }
    
    func optionTapped(type: ProfileModels.OptionsItemType) {
        switch type {
        case .changePassword:
            //coordinator?.push(destination: .changePassword)
            print("Change password")
        case .closeSession:
            confirmationDialogModel.isShown = true
        }
    }
    
    func closeSession() async {
        let result = await logoutUserUseCase.execute()
        switch result {
        case .success:
            changeState(.loggedOut)
        case .failure:
            print("Error clossing session")
        }
    }
}








