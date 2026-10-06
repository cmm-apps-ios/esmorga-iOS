//
//  PollListViewModel.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 23/9/26.
//

import Foundation
import FirebaseCrashlytics

enum PollListViewStates: ViewStateProtocol {
    case ready
    case loading
    case loaded
    case error
    case empty
}

class PollListViewModel: BaseViewModel<PollListViewStates> {

    @Published var polls: [Poll] = []
    private let getPollListUseCase: GetPollsUseCaseAlias

    init(coordinator: (any CoordinatorProtocol)?,
         getPollListUseCase: GetPollsUseCaseAlias = GetPollsUseCase()) {
        self.getPollListUseCase = getPollListUseCase
        super.init(coordinator: coordinator)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePollUpdated(notification:)),
            name: .pollUpdated,
            object: nil
        )
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    func pollTapped(_ poll: Poll) {
        coordinator?.push(destination: .pollDetails(poll))
    }

    @objc
    private func handlePollUpdated(notification: Notification) {
        guard let updatedPoll = notification.userInfo?["poll"] as? Poll,
              let index = polls.firstIndex(where: { $0.id == updatedPoll.id }) else {
            return
        }
        polls[index] = updatedPoll
    }

    @MainActor
    func getPollList(forceRefresh: Bool) async {

        if self.state == .ready || forceRefresh {
            changeState(.loading)
        }

        let result = await getPollListUseCase.execute()

        switch result {
        case .success(let polls):
            self.polls = polls
            if polls.isEmpty {
                self.changeState(.empty)
            } else {
                self.changeState(.loaded)
            }
        case .failure:
            self.changeState(.error)
        }
    }
}
