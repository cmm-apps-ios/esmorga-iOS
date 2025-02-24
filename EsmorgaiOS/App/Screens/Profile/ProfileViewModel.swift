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
    //Dialog -> Le gustará a Omar? Lo dudo
    
    // @Published var showLogoutConfirmation: Bool = false
    // var logoutAction: (() -> Void)?
    
    //Logged model
    @Published var loggedModel: ProfileModels.LoggedModel?
    //Model loggedOut
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    @Published var confirmationDialog = ConfirmationDialogModel(title: LocalizationKeys.Profile.logoutPopupDescription.localize(), isShown: false,  primaryButtonTitle: LocalizationKeys.Profile.logoutPopupConfirm.localize(), secondaryButtonTitle: LocalizationKeys.Profile.logoutPopupCancel.localize())
    
    
    //Init
    init(coordinator: (any CoordinatorProtocol)? = nil,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         logoutUserUseCase: LogoutUserUseCaseAlias = LogoutUserUseCase(),
         mapper: ProfileViewModelMapper = ProfileViewModelMapper()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.mapper = mapper
        super.init(coordinator: coordinator)
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
            confirmationDialog.isShown = true //Le gustará esta porquería?
        }
    }
}


func closeSession() {
    print("Cerrar sesión")
}




