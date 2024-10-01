//
//  BaseViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation

class BaseViewModel<E: ViewStateProtocol>: ObservableObject {
    @Published var state: E = .ready
    @Published var snackBar: SnackbarView.Model = .init()

    weak var coordinator: (any CoordinatorProtocol)?
    var networkMonitor: NetworkMonitorProtocol!

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared) {
        self.coordinator = coordinator
        self.networkMonitor = networkMonitor
    }

    func changeState(_ state: E) {
        DispatchQueue.main.async { [weak self] in
            if self?.state != state {
                self?.state = state
                debugPrint("State changed to \(state)")
            }
        }
    }
}
