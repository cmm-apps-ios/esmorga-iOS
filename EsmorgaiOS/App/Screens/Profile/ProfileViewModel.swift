//
//  ProfileViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

enum ProfileViewStates: ViewStateProtocol {
    //States
    case ready
    case loggedOut
}

class ProfileViewModel: BaseViewModel<ProfileViewStates> {
    
    //Model LocalUser
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    //Model Logout
    private let logoutUserUseCase: LogoutUserUseCaseAlias
    //Mapper
    private let mapper: ProfileViewModelMapper
    //Model LoggedModel
    var user: UserModels.User?
    
    //Logged model
    @Published var loggedModel: ProfileModels.LoggedModel?
    //Model loggedOut
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    @Published var confirmationDialogModel: ConfirmationDialogView.Model
    
    //Init
    init(coordinator: (any CoordinatorProtocol)? = nil,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         logoutUserUseCase: LogoutUserUseCaseAlias = LogoutUserUseCase(),
         mapper: ProfileViewModelMapper = ProfileViewModelMapper()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.mapper = mapper
        self.confirmationDialogModel = ConfirmationDialogView.Model(title: LocalizationKeys.Profile.logoutPopupDescription.localize(),
                                                                    isShown: false,
                                                                    primaryButtonTitle: LocalizationKeys.Profile.logoutPopupConfirm.localize(),
                                                                    secondaryButtonTitle: LocalizationKeys.Profile.logoutPopupCancel.localize(),
                                                                    primaryAction: nil,
                                                                    secondaryAction: nil)
        super.init(coordinator: coordinator)
        
        self.confirmationDialogModel.primaryAction = {
            Task {
                await self.closeSession()
            }
        }
    }
    
    //Verify is user is loggedIn
    @MainActor
    func checkLoginStatus() async {
        let isUserLogged = await getLocalUserUseCase.execute()
        switch isUserLogged {
        case .success(let user): //Change state + obtain user data
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








