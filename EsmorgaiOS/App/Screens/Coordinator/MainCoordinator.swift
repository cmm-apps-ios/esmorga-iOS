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

    /// Shared ViewModel that lives for the whole create-event flow so state is
    /// preserved while navigating back and forth (Option A). It is created lazily
    /// when the flow starts and released when the flow returns to the root.
    private var createEventViewModel: CreateEventViewModel?

    func push(destination: Destination) {
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
        createEventViewModel = nil
    }

    private func sharedCreateEventViewModel() -> CreateEventViewModel {
        if let viewModel = createEventViewModel { return viewModel }
        let viewModel = CreateEventViewModel(coordinator: self)
        createEventViewModel = viewModel
        return viewModel
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
        case .activate(let code):
            ActivateAccountBuilder().build(coordinator: self, code: code)
        case .recoverPassword:
            RecoverPasswordBuilder().build(coordinator: self)
        case .resetPassword(let code):
            //Cambiar
           ResetPasswordBuilder().build(coordinator: self, code: code)
        case .changePassword:
            ChangePasswordBuilder().build(coordinator: self)
        case .dialog(let model):
            let viewModel = ErrorDialogViewModel(coordinator: self)
            ErrorDialog(viewModel: viewModel, model: model)
        case .eventList:
            EventListBuilder().build(coordinator: self)
        case .eventDetails(let event):
            EventDetailsBuilder().build(coordinator: self, event: event)
        case .eventAttendees(let eventId):
            EventAttendeesBuilder().build(coordinator: self, eventId: eventId)
        case .dashboard:
            DashboardBuilder().build(coordinator: self)
        case .createEvent:
            CreateEventBuilder().build(viewModel: sharedCreateEventViewModel(), step: .name)
        case .createEventType:
            CreateEventBuilder().build(viewModel: sharedCreateEventViewModel(), step: .type)
        case .createEventDate:
            CreateEventBuilder().build(viewModel: sharedCreateEventViewModel(), step: .date)
        case .createEventLocation:
            CreateEventBuilder().build(viewModel: sharedCreateEventViewModel(), step: .location)
        case .createEventImage:
            CreateEventBuilder().build(viewModel: sharedCreateEventViewModel(), step: .image)
        }
    }

    func openExtrenalApp(_ method: DeepLinkModels.Method) {
        UIApplication.shared.open(method.url, options: [: ], completionHandler: nil)
    }
}
