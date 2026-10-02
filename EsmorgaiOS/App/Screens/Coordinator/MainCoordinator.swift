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

    /// Use case that clears the local session when the user is forced out (e.g. an
    /// expired/invalid refresh token returns 401 while performing an authenticated
    /// request such as creating an event).
    private let logoutUserUseCase: LogoutUserUseCaseAlias

    /// Prevents stacking multiple logout navigations when several authenticated
    /// requests fail with 401 at once (each one posts `.forceLogout`).
    private var isHandlingForcedLogout = false

    init(logoutUserUseCase: LogoutUserUseCaseAlias = LogoutUserUseCase()) {
        self.logoutUserUseCase = logoutUserUseCase
    }

    func push(destination: Destination) {
        // Starting the create-event flow anew must not reuse a previous shared
        // ViewModel (otherwise re-entering the wizard shows stale fields/errors).
        // The back button uses SwiftUI's dismiss(), so pop() is not guaranteed to
        // run when the user abandons the flow — resetting on entry is reliable.
        if destination == .createEvent {
            createEventViewModel = nil
        }
        path.append(destination)
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
        createEventViewModel = nil
    }

    /// Handles a forced logout triggered by `.forceLogout`. Without this, an
    /// authenticated request that fails to refresh its token (e.g. submitting the
    /// create-event form with an expired session) would only show the generic
    /// retry dialog on a loop, trapping the user. Here we clear the session and
    /// reset navigation to the Welcome screen so the user can log in again.
    @MainActor
    func handleForcedLogout() {
        guard !isHandlingForcedLogout else { return }
        isHandlingForcedLogout = true

        Task {
            _ = await logoutUserUseCase.execute()
            createEventViewModel = nil
            path.removeLast(path.count)
            path.append(Destination.welcome)
            isHandlingForcedLogout = false
        }
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
