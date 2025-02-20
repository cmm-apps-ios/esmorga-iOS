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
    //Mapper
    private let mapper: ProfileViewModelMapper
    //Model LoggedModel
    @Published var loggedModel: ProfileModels.LoggedModel?
    //Model loggedOut
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    //Init
    init(coordinator: (any CoordinatorProtocol)? = nil,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         mapper: ProfileViewModelMapper = ProfileViewModelMapper()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        self.mapper = mapper
        super.init(coordinator: coordinator)
    }
    
    //Verify is user is loggedIn
    @MainActor
    func checkLoginStatus() async {
        let isUserLogged = await getLocalUserUseCase.execute()
        switch isUserLogged {
        case .success(let user): //Change state + obtain user data
           // self.user = user
            self.loggedModel = mapper.map(user: user)
            changeState(.ready)
        case .failure:
            changeState(.loggedOut)
        }
    }
    
    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }
    
    func optionTapped(type: ProfileModels.OptionsItemType){
        switch type {
        case .changePassword:
            //To add ->   coordinator?.push(destination: .changePassword)
            print("Change Password")
        case .closeSession:
            //logoutUserUseCase.execute (to define)
            print("Close Sesion")
        }
    }
    //Profile Mapper
    class ProfileViewModelMapper {
        func map(user: UserModels.User) -> ProfileModels.LoggedModel {
            
            let userItems = [ProfileModels.UserDataItem(title: "Nombre", value: user.name + user.lastName, type: .name),
                             ProfileModels.UserDataItem(title: "Email", value: user.email, type: .email)]
            
            
            let optionsItems = [ProfileModels.OptionItem(title: "Cambiar Contraseña",
                                                         image: "arrow.right",
                                                         type: .changePassword),
                                ProfileModels.OptionItem(title: "Cerrar sesión",
                                                         image: "arrow.right",
                                                         type: .closeSession)]

            return ProfileModels.LoggedModel(userSection: ProfileModels.UserData(items: userItems), optionsSection: ProfileModels.Options(title: "Opciones", items: optionsItems))
                
        }
    }
    
}
