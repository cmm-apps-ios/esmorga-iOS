//
//  ProfileViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

enum ProfileViewStates: ViewStateProtocol {
    //'To be determined...'
    case ready
    case loggedOut
}

class ProfileViewModel: BaseViewModel<ProfileViewStates> {
    
    //'I need error Model in this screen'?
    @Published var errorModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                          title: LocalizationKeys.DefaultError.title.localize(),
                                                          buttonText: LocalizationKeys.Buttons.retry.localize())
    @Published var loggedOutModel = MyEventsModels.ErrorModel(animation: .suspiciousMonkey,
                                                              title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                                              buttonText: LocalizationKeys.Buttons.login.localize())
    
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    
    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator,
                   networkMonitor: networkMonitor)
    }
    
    //'Probably i need this...'
    func loginButtonTapped() {
        coordinator?.push(destination: .login)
    }
    
}
