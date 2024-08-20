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

    @ViewBuilder
    func viewToDisplay(router: Router<MainRoute>) -> some View {
        switch self {
        case .login:
            Text("Login")
        case .list:
            EventListBuilder().build(mainRouter: router)
        case .details(let event):
            EventDetailsBuilder().build(mainRouter: router, event: event)
        }
    }

    var navigationType: NavigationType {
        return .push
    }
}
