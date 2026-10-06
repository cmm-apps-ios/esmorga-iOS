//
//  ExploreHomeBuilder.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 25/9/26.
//

import Foundation

class ExploreHomeBuilder {

    func build(coordinator: (any CoordinatorProtocol)? = nil,
              isUserLogged: Bool = AccountSession.buildCodableKeychain().isLogged) -> ExploreHomeView {
        let eventListViewModel = EventListViewModel(coordinator: coordinator)
        let exploreViewModel = ExploreHomeViewModel(coordinator: coordinator,
                                                    eventListViewModel: eventListViewModel,
                                                    pollListViewModel: isUserLogged ? PollListViewModel(coordinator: coordinator) : nil)
        return ExploreHomeView(viewModel: exploreViewModel)
    }
}
