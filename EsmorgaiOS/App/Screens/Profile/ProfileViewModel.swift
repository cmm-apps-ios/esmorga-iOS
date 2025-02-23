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
    @Published var showLogoutConfirmation: Bool = false
    var logoutAction: (() -> Void)?
    //Logged model
    @Published var loggedModel: ProfileModels.LoggedModel?
    //Model loggedOut
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
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
            showLogoutConfirmation = true //Le gustará esta porquería?
            logoutAction = { [weak self] in
                Task {
                    await self?.closeSession()
                }
            }
        }
    }
    
    func confirmLogout() {
        showLogoutConfirmation = false
        logoutAction?()
    }
    
    @MainActor
    func closeSession() async {
        let result = await logoutUserUseCase.execute()
        switch result {
        case .success:
            self.changeState(.loggedOut)
        case .failure:
            print("Error")
        }
    }
}


//Profile Mapper
class ProfileViewModelMapper {
    func map(user: UserModels.User) -> ProfileModels.LoggedModel {
        
        let userItems = [ProfileModels.UserDataItem(title:LocalizationKeys.Profile.name.localize(), value: user.name + user.lastName, type: .name),
                         ProfileModels.UserDataItem(title:LocalizationKeys.Profile.email.localize(), value: user.email, type: .email)]
        
        
        
        let optionsItems = [ProfileModels.OptionItem(title: LocalizationKeys.Profile.changePassword.localize(),
                                                     image: "arrow.right",
                                                     type: .changePassword),
                            ProfileModels.OptionItem(title: LocalizationKeys.Profile.logout.localize(),
                                                     image: "arrow.right",
                                                     type: .closeSession)]
        
        return ProfileModels.LoggedModel(userSection: ProfileModels.UserData(items: userItems), optionsSection: ProfileModels.Options(title: LocalizationKeys.Profile.options.localize(), items: optionsItems))
        
    }
}


