//
//  MainRoute.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Foundation
import SwiftUI

enum MainRoute: Routable {
    case login
    case list
    case details(EventModels.Event)
    case register
    case dialog(ErrorDialog.Model)

    @ViewBuilder
    func viewToDisplay(router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            LoginBuilder().build(mainRouter: router)
        case .list:
            EventListBuilder().build(mainRouter: router)
        case .details(let event):
            EventDetailsBuilder().build(mainRouter: router, event: event)
        case .register:
            RegistrationBuilder().build(mainRouter: router)
        case .dialog(let model):
            ErrorDialog(model: model)
        }
    }

    var navigationType: NavigationType {
        return .push
    }
}
