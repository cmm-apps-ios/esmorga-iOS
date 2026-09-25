//
//  CreateEventLocationView.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

struct CreateEventLocationView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CreateEventViewModel

    init(viewModel: CreateEventViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    Text(LocalizationKeys.CreateEvent.title.localize())
                        .style(.heading1)
                        .padding(.top, 20)

                    CustomTextField(text: $viewModel.location,
                                    caption: $viewModel.locationError,
                                    title: LocalizationKeys.CreateEvent.fieldTitleLocation.localize(),
                                    hint: LocalizationKeys.CreateEvent.placeholderLocation.localize())
                    .onFocusChange { isFocused in
                        if !isFocused { viewModel.validateLocation() }
                    }

                    CustomTextField(text: $viewModel.coordinates,
                                    caption: $viewModel.coordinatesError,
                                    title: LocalizationKeys.CreateEvent.fieldTitleCoordinates.localize(),
                                    hint: LocalizationKeys.CreateEvent.placeholderCoordinates.localize())
                    .onFocusChange { isFocused in
                        if !isFocused { viewModel.validateCoordinates() }
                    }

                    CustomTextField(text: $viewModel.maxCapacity,
                                    caption: $viewModel.maxCapacityError,
                                    title: LocalizationKeys.CreateEvent.fieldTitleMaxCapacity.localize(),
                                    hint: LocalizationKeys.CreateEvent.placeholderMaxCapacity.localize())
                    .onFocusChange { isFocused in
                        if !isFocused { viewModel.validateMaxCapacity() }
                    }
                    .keyboardType(.numberPad)

                    CustomButton(title: .constant(LocalizationKeys.CreateEvent.continueButton.localize()),
                                 buttonStyle: .primary,
                                 isDisabled: .constant(!viewModel.canProceedFromLocationStep)) {
                        viewModel.goToImageStep()
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBar {
            dismiss()
        }
    }
}
