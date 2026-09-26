//
//  PollDetailsBuilder.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 23/9/26.
//

import Foundation

class PollDetailsBuilder {

    func build(coordinator: any CoordinatorProtocol, poll: Poll) -> PollDetailsView {
        let viewModel = PollDetailsViewModel(poll: poll)
        return PollDetailsView(viewModel: viewModel)
    }
}
