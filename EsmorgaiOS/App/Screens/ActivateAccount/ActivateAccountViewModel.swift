//
//  ActivateAccountViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

enum ActivateAccountViewStates: ViewStateProtocol {
    case ready
}

class ActivateAccountViewModel: BaseViewModel<ActivateAccountViewStates> {

    @Published var primaryButton = LoginModels.Button(title: "Continuar",
                                                      isLoading: false)

    private let code: String

    init(coordinator: (any CoordinatorProtocol)?, networkMonitor: NetworkMonitorProtocol? = NetworkMonitor.shared, navigationManager: ExternalAppsManagerProtocol = ExternalAppsManager(), code: String) {

        self.code = code
        print("INIT con code:", code)

        super.init(coordinator: coordinator, networkMonitor: networkMonitor!)
    }
}
