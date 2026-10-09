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
    private var event: EventModels.Event
    private var user: UserModels.User?

    @Published var showMethodsAlert: Bool = false
    @Published var model: EventDetails.Model = .empty
    var navigationMethods = [DeepLinkModels.Method]()

    @Published var attendeesText: String = ""
    @Published var showSeeAttendeesButton: Bool = false
    @Published var showSeeAttendeesCount: Bool = false
    @Published var showDescription: Bool = false

    init(coordinator: (any CoordinatorProtocol)?,
         networkMonitor: NetworkMonitorProtocol = NetworkMonitor.shared,
         event: EventModels.Event,
         navigationManager: ExternalAppsManagerProtocol = ExternalAppsManager(),
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase(),
         joinEventUseCase: JoinEventUseCaseAlias = JoinEventUseCase(),
         leaveEventUseCase: LeaveEventUseCaseAlias = LeaveEventUseCase()) {
        self.deepLinkManager = navigationManager
        self.event = event
        self.getLocalUserUseCase = getLocalUserUseCase
        self.joinEventUseCase = joinEventUseCase
        self.leaveEventUseCase = leaveEventUseCase
        super.init(coordinator: coordinator,
                   networkMonitor: networkMonitor)
    }

    @MainActor
    func viewLoad() async {
        user = try? await getLocalUserUseCase.execute().get()
        let isUserLogged = user != nil
        showEventModel()
        changeState(.loaded(isLogged: isUserLogged))
        setupAttendeesCountText()
        showDescription = !event.details.isEmpty
    }

    @MainActor
    private func setupAttendeesCountText() {
        let isUserLogged = user != nil
        guard isUserLogged else { return }
        self.attendeesText = LocalizationKeys.EventDetails.attendeesCount.localize(self.event.currentAttendeeCount, event.maxCapacity)
        self.showSeeAttendeesButton = (self.event.currentAttendeeCount > 0)
        self.showSeeAttendeesCount = event.maxCapacity > 0
    }
    
    @MainActor
    private func updateAttendeesCount() {
        NotificationCenter.default.post(
            name: .eventUpdated,
            object: nil,
            userInfo: ["event": self.event]
        )
        
        setupAttendeesCountText()
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
            self.event.currentAttendeeCount -= 1
            self.updateAttendeesCount()
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
            self.event.currentAttendeeCount += 1
            self.updateAttendeesCount()
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
