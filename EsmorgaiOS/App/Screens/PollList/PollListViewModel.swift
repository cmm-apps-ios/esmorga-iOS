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
    }

    func pollTapped(_ poll: Poll) {
        // TODO: Implement when poll details
        //coordinator?.push(destination: .pollDetails(poll))
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
