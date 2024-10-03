//
//  EventDetailsView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 26/7/24.
//

import SwiftUI
import UIKit

struct EventDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EventDetailsViewModel

    init(viewModel: EventDetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            switch viewModel.state {
            case .ready:
                EmptyView()
            case .loaded:
                ScrollView {
                    AsyncImage(url: viewModel.model.imageUrl) { image in
                        image.resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    } placeholder: {
                        Image("placeholder-esmorga")
                            .resizable()
                            .aspectRatio(16/9, contentMode: .fill)
                    }
                    .padding(.bottom, 24)
                    VStack(alignment: .leading) {
                        Text(viewModel.model.title)
                            .style(.title)
                            .padding(.bottom, 16)
                        Text(viewModel.model.body)
                            .style(.body1Accent)
                            .padding(.bottom, 29)
                        Text(viewModel.model.descriptionTitle)
                            .style(.heading1)
                            .padding(.bottom, 16)
                        Text(viewModel.model.descriptionBody)
                            .style(.body1)
                            .padding(.bottom, 32)
                        Text(viewModel.model.locationTitle)
                            .style(.heading1)
                            .padding(.bottom, 16)
                        Text(viewModel.model.locationBody)
                            .style(.body1)
                            .padding(.bottom, 12)
                        VStack(spacing: 32) {
                            CustomButton(title: viewModel.model.secondaryButtonText,
                                         buttonStyle: .secondary) {
                                viewModel.openLocation()
                            }
                            CustomButton(title: viewModel.model.primaryButtonText,
                                         buttonStyle: .primary) {
                                viewModel.primaryButtonTapped()
                            }
                        }.padding(.top, 32)

                    }.padding(.horizontal, 16)
                }
                .alert("Selecciona tu app de navigacion", isPresented: $viewModel.showMethodsAlert) {
                    ForEach(viewModel.navigationMethods, id: \.title) { method in
                        Button(method.title) {
                            viewModel.openNavigationMethod(method)
                        }
                    }
                    Button("Cancelar", role: .cancel) { }
                }
            }
        }
        .onFirstAppear {
            Task {
                await viewModel.viewLoad()
            }
        }
        .navigationBar {
            dismiss()
        }
    }
}
