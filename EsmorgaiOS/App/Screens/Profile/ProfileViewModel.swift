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
    //Model loggedOut
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    init(coordinator: (any CoordinatorProtocol)? = nil, getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator)
        Task {
            await self.checkLoginStatus(forceRefresh: false)
        }
    }
    
    //Verify is user is loggedIn
    @MainActor
    func checkLoginStatus(forceRefresh: Bool) async {
        let isUserLogged = await getLocalUserUseCase.execute()
        switch isUserLogged {
       // case .success(let user):
        case .success:
            changeState(.ready)
        case .failure:
            changeState(.loggedOut)
        }
    }
    
    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }
    
}
