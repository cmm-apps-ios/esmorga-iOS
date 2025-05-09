//
//  MainCoordinator.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import SwiftUI

protocol CoordinatorProtocol: AnyObject {
    associatedtype ViewType: View

    func push(destination: Destination)
    func pop()
    func popToRoot()
    func build(destination: Destination) -> ViewType
    func openExtrenalApp(_ method: DeepLinkModels.Method)
}

class MainCoordinator: ObservableObject, CoordinatorProtocol {
    @Published var path: NavigationPath = NavigationPath()

    func push(destination: Destination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    @ViewBuilder
    func build(destination: Destination) -> some View {
        switch destination {
        case .splash:
            SplashBuilder().build(coordinator: self)
        case .welcome:
            WelcomeScreenBuilder().build(coordinator: self)
        case .login:
            LoginBuilder().build(coordinator: self)
        case .register:
            RegistrationBuilder().build(coordinator: self)
        case .confirmRegister(let email):
            RegistrationConfirmBuilder().build(coordinator: self, email: email)
        case .dialog(let model):
            ErrorDialog(model: model)
        case .eventList:
            EventListBuilder().build(coordinator: self)
        case .eventDetails(let event):
            EventDetailsBuilder().build(coordinator: self, event: event)
        case .dashboard:
            DashboardBuilder().build(coordinator: self)
        }
    }

    func openExtrenalApp(_ method: DeepLinkModels.Method) {
        UIApplication.shared.open(method.url, options: [: ], completionHandler: nil)
    }
}
