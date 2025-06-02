//
//  ErrorDialogViewModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/5/25.
//

import Foundation
import SwiftUI

enum ErrorDialogViewStates: ViewStateProtocol {
    case ready
}

class ErrorDialogViewModel: BaseViewModel<ErrorDialogViewStates> {


    init(coordinator: (any CoordinatorProtocol)?) {
        super.init(coordinator: coordinator)
    }

    func backToMain() {
        self.coordinator?.popToRoot()
        self.coordinator?.push(destination: .welcome)
    }
}
