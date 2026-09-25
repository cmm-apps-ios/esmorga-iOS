//
//  ExploreHomeViewModel.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 25/9/26.
//

import Foundation

enum ExploreHomeViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
}

class ExploreHomeViewModel: BaseViewModel<ExploreHomeViewStates> {

    @Published var errorModel = ExploreHomeModels.ErrorModel(imageName: "AlertEsmorga",
        title: LocalizationKeys.DefaultError.title.localize(),
        subtitle: LocalizationKeys.DefaultError.body.localize(),
        buttonText: LocalizationKeys.Buttons.retry.localize())

    private let eventListViewModel: EventListViewModel
    private let pollListViewModel: PollListViewModel?
    private let getLocalUserUseCase: GetLocalUserUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?,
         eventListViewModel: EventListViewModel,
         pollListViewModel: PollListViewModel? = nil,
         getLocalUserUseCase: GetLocalUserUseCaseAlias = GetLocalUserUseCase()) {
        self.eventListViewModel = eventListViewModel
        self.pollListViewModel = pollListViewModel
        self.getLocalUserUseCase = getLocalUserUseCase
        super.init(coordinator: coordinator)
    }

    var events: [EventModels.Event] { eventListViewModel.events }

    var polls: [Poll] { pollListViewModel?.polls ?? [] }

    var isUserLogged: Bool { pollListViewModel != nil }

    func eventTapped(_ event: EventModels.Event) {
        eventListViewModel.eventTapped(event)
    }

    func pollTapped(_ poll: Poll) {
        pollListViewModel?.pollTapped(poll)
    }

    @MainActor
    func load(forceRefresh: Bool) async {

        if self.state == .ready || forceRefresh {
            changeState(.loading)
        }

        await loadEvents(forceRefresh: forceRefresh)
        await loadPolls(forceRefresh: forceRefresh)

        updateState()
    }

    func retry() async {
        await load(forceRefresh: true)
    }

    @MainActor
    private func loadEvents(forceRefresh: Bool) async {
        await eventListViewModel.getEventList(forceRefresh: forceRefresh)
    }

    @MainActor
    private func loadPolls(forceRefresh: Bool) async {
        guard let pollListViewModel else { return }
        await pollListViewModel.getPollList(forceRefresh: forceRefresh)
    }

    private func updateState() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            let eventsError = self.eventListViewModel.state == .error
            let pollsError = self.pollListViewModel.map { $0.state == .error } ?? false
            if !eventsError && !pollsError {
                self.changeState(.loaded)
            } else {
                self.changeState(.error)
                self.reportErrorToCrashlytics()
            }
        }
    }
}
