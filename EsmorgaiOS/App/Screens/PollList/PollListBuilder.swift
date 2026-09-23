//
//  PollListBuilder.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 23/9/26.
//

import Foundation

class PollListBuilder {

    func build(coordinator:( any CoordinatorProtocol)? = nil) -> PollListView {
        let viewModel = PollListViewModel(coordinator: coordinator)
        return PollListView(viewModel: viewModel)
    }
}
