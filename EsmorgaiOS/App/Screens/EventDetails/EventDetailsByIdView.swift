//
//  EventDetailsByIdView.swift
//  EsmorgaiOS
//
//  Loading boundary shown while a push notification's eventId is resolved.
//

import SwiftUI

struct EventDetailsByIdView: View {

    @StateObject var viewModel: EventDetailsByIdViewModel

    init(viewModel: EventDetailsByIdViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            switch viewModel.state {
            case .ready:
                ProgressView()
            case .notFound:
                VStack(spacing: 16) {
                    Text(LocalizationKeys.EventDetails.byIdUnavailableTitle.localize())
                        .style(.title)
                        .multilineTextAlignment(.center)
                    Text(LocalizationKeys.EventDetails.byIdUnavailableBody.localize())
                        .style(.body1)
                        .multilineTextAlignment(.center)
                    CustomButton(title: LocalizationKeys.EventDetails.byIdUnavailableAction.localize()) {
                        viewModel.backToEventsTapped()
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 32)
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.viewLoad()
            }
        }
    }
}
