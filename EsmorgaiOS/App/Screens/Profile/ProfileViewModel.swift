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




    @Published var errorDialogModel: ErrorDialog.Model?

    init(coordinator: (any CoordinatorProtocol)? = nil,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         logoutUserUseCase: LogoutUserUseCaseAlias = LogoutUserUseCase(),
         mapper: ProfileViewModelMapper = ProfileViewModelMapper()) {
        self.getLocalUserUseCase = getLocalUserUseCase
        self.logoutUserUseCase = logoutUserUseCase
        self.mapper = mapper
        super.init(coordinator: coordinator, networkMonitor: networkMonitor)
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
            guard networkMonitor.isConnected else {
                self.showErrorDialog(type: .noInternet)
                self.reportErrorToCrashlytics()
                return
            }

        case .closeSession:
            showConfirmationDialog()
        }
    }

    private func showErrorDialog(type: ErrorDialog.DialogType) {
        let dialogModel = ErrorDialogModelBuilder.build(type: type)
        coordinator?.push(destination: .dialog(dialogModel))
    }

    func showConfirmationDialog() {
        let secondaryAction: (() -> Void)? = {
            Task {
                await self.closeSession()

            }
        }
        self.confirmationDialog = ConfirmationDialogView.Model(title: LocalizationKeys.Profile.logoutPopupDescription.localize(),
                                                                    isShown: true,
                                                                    primaryButtonTitle: LocalizationKeys.Profile.logoutPopupCancel.localize(),
                                                                    secondaryButtonTitle: LocalizationKeys.Profile.logoutPopupConfirm.localize(),
                                                                    primaryAction: nil,
                                                                    secondaryAction: secondaryAction)
    }
   

    func closeSession() async {
        let result = await logoutUserUseCase.execute()
        switch result {
        case .success:
            self.user = nil
            changeState(.loggedOut)
        case .failure:
            print("Error clossing session")
        }
    }
}
