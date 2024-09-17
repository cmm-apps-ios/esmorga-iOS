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
    var event: EventModels.Event

    init(viewModel: EventDetailsViewModel,
         event: EventModels.Event) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.event = event
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                AsyncImage(url: event.imageURL) { image in
                    image.resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                } placeholder: {
                    Image("placeholder-esmorga")
                        .resizable()
                        .aspectRatio(16/9, contentMode: .fill)
                }
                .padding(.bottom, 24)
                VStack(alignment: .leading) {
                    Text(event.name)
                        .style(.title)
                        .padding(.bottom, 16)
                    Text(event.date.string(format: .dayMonthHour) ?? "")
                        .style(.body1Accent)
                        .padding(.bottom, 29)
                    Text(LocalizationKeys.EventDetails.description.localize())
                        .style(.heading1)
                        .padding(.bottom, 16)
                    Text(event.details)
                        .style(.body1)
                        .padding(.bottom, 32)
                    Text(LocalizationKeys.EventDetails.location.localize())
                        .style(.heading1)
                        .padding(.bottom, 16)
                    Text(event.location)
                        .style(.body1)
                        .padding(.bottom, 12)
                    VStack(spacing: 32) {
                        CustomButton(title: LocalizationKeys.Buttons.navigate.localize(),
                                     buttonStyle: .secondary) {
                            viewModel.openLocation(latitude: event.latitude, longitude: event.longitude)
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
        .navigationBar {
            dismiss()
        }
    }
}
