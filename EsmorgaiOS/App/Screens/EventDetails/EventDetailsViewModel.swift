//
//  EventDetailsViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/8/24.
//

import Foundation

enum EventDetailsViewState: ViewStateProtocol {
    case ready
    case loaded(isLogged: Bool)
}

class EventDetailsViewModel: BaseViewModel<EventDetailsViewState> {

    private let deepLinkManager: ExternalAppsManagerProtocol
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias
    private let joinEventUseCase: JoinEventUseCaseAlias
    private let leaveEventUseCase: LeaveEventUseCaseAlias
    private let getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias
    private var event: EventModels.Event
    private var user: UserModels.User?

    @Published var showMethodsAlert: Bool = false
    @Published var model: EventDetails.Model = .empty
    var navigationMethods = [DeepLinkModels.Method]()

    @Published var attendeesText: String = ""
    @Published var showSeeAttendeesButton: Bool = false

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         event: EventModels.Event,
         navigationManager: ExternalAppsManagerProtocol = ExternalAppsManager(),
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         joinEventUseCase: JoinEventUseCaseAlias = JoinEventUseCase(),
         leaveEventUseCase: LeaveEventUseCaseAlias = LeaveEventUseCase(),
         getEventAttendeesUseCase: GetEventAttendeesUseCaseAlias = GetEventAttendeesUseCase()) {
        self.deepLinkManager = navigationManager
        self.event = event
        self.getLocalUserUseCase = getLocalUserUseCase
        self.joinEventUseCase = joinEventUseCase
        self.leaveEventUseCase = leaveEventUseCase
        self.getEventAttendeesUseCase = getEventAttendeesUseCase
        super.init(coordinator: coordinator,
                   networkMonitor: networkMonitor)
    }

    @MainActor
    func viewLoad() async {
        user = try? await getLocalUserUseCase.execute().get()
        let isUserLogged = user != nil
        showEventModel()
        changeState(.loaded(isLogged: isUserLogged))
        await loadAttendeesCount()
    }

    @MainActor
    private func loadAttendeesCount() async {
        let result = await getEventAttendeesUseCase.execute(input: event.eventId)
        let count: Int
        if case .success(let attendees) = result {
            count = attendees.count
        } else {
            count = 0
        }
        self.attendeesText = LocalizationKeys.EventDetails.attendeesCount.localize(count, event.maxCapacity)
        self.showSeeAttendeesButton = (count > 0) && (user?.role == .admin)
    }

    private func showEventModel() {
        let isUserLogged = user != nil
        model = EventDetailsMapper.mapEventDetails(event, isUserLogged: isUserLogged)
    }

    func openLocation() {

        guard let latitude = event.latitude, let longitude = event.longitude else { return }
        navigationMethods = deepLinkManager.getMapMethods(latitude: latitude, longitude: longitude)
        if navigationMethods.count == 1, let method = navigationMethods.first {
            openNavigationMethod(method)
        } else {
            showMethodsAlert = true
        }
    }

    func openNavigationMethod(_ method: DeepLinkModels.Method) {
        coordinator?.openExtrenalApp(method)
    }

    @MainActor
    func primaryButtonTapped() async {
        switch state {
        case .loaded(let isLogged):
            guard isLogged else {
                coordinator?.push(destination: .login)
                return
            }

            guard networkMonitor.isConnected else {
                self.showErrorDialog(type: .noInternet)
                self.reportErrorToCrashlytics()
                return
            }

            event.isUserJoined ? await leaveEvent() : await joinEvent()
        case .ready: break
        }
    }

    @MainActor
    private func leaveEvent() async {

        model.primaryButton.isLoading = true

        let result = await leaveEventUseCase.execute(input: event.eventId)
        switch result {
        case .success:
            self.event.isUserJoined = false
            self.showEventModel()
            self.snackBar = .init(message: LocalizationKeys.Snackbar.eventLeft.localize(),
                                  isShown: true)
            await self.loadAttendeesCount()
        case .failure:
            self.showErrorDialog(type: .commonError)
        }
        self.model.primaryButton.isLoading = false
        
    }

    @MainActor
    private func joinEvent() async {

        model.primaryButton.isLoading = true

        let result = await joinEventUseCase.execute(input: event.eventId)

        switch result {
        case .success:
            self.event.isUserJoined = true
            self.showEventModel()
            self.snackBar = .init(message: LocalizationKeys.Snackbar.eventJoined.localize(),
                                  isShown: true)
            await self.loadAttendeesCount()
        case .failure:
            self.showErrorDialog(type: .commonError)
        }
        self.model.primaryButton.isLoading = false
        
    }

    private func showErrorDialog(type: ErrorDialog.DialogType) {
        let dialogModel = ErrorDialogModelBuilder.build(type: type)
        coordinator?.push(destination: .dialog(dialogModel))
    }
    
    func seeEventAttendees() {
        coordinator?.push(destination: Destination.eventAttendees(eventId: self.event.eventId))
    }
}
