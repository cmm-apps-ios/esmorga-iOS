//
//  CreateEventBuilder.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

/// The individual steps of the create-event wizard.
enum CreateEventStep {
    case name
    case type
    case date
    case location
    case image
}

/// Builds each step of the create-event flow from a single, shared ViewModel so
/// the state is preserved while navigating back and forth (Option A).
class CreateEventBuilder {

    @ViewBuilder
    func build(viewModel: CreateEventViewModel, step: CreateEventStep) -> some View {
        switch step {
        case .name:
            CreateEventNameView(viewModel: viewModel)
        case .type:
            CreateEventTypeView(viewModel: viewModel)
        case .date:
            CreateEventDateView(viewModel: viewModel)
        case .location:
            CreateEventLocationView(viewModel: viewModel)
        case .image:
            CreateEventImageView(viewModel: viewModel)
        }
    }
}

