//
//  CreateEventNameView.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

struct CreateEventNameView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CreateEventViewModel

    init(viewModel: CreateEventViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(LocalizationKeys.CreateEvent.title.localize())
                        .style(.heading1)
                        .padding(.top, 20)

                    CustomTextField(text: $viewModel.eventName,
                                    caption: $viewModel.eventNameError,
                                    title: LocalizationKeys.CreateEvent.fieldTitleName.localize(),
                                    hint: LocalizationKeys.CreateEvent.placeholderName.localize())
                    .onFocusChange { isFocused in
                        if !isFocused { viewModel.validateName() }
                    }

                    CustomTextField(text: $viewModel.description,
                                    caption: $viewModel.descriptionError,
                                    title: LocalizationKeys.CreateEvent.fieldTitleDescription.localize(),
                                    hint: LocalizationKeys.CreateEvent.placeholderDescription.localize())
                    .onFocusChange { isFocused in
                        if !isFocused { viewModel.validateDescription() }
                    }

                    CustomButton(title: .constant(LocalizationKeys.CreateEvent.continueButton.localize()),
                                 buttonStyle: .primary,
                                 isDisabled: .constant(!viewModel.canProceedFromNameStep)) {
                        viewModel.goToTypeStep()
                    }
                    .padding(.top, 24)
                }
                .padding(.horizontal, 16)
            }
        }
        .navigationBar {
            dismiss()
        }
    }
}
