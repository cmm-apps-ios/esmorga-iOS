//
//  CreateEventDateView.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

struct CreateEventDateView: View {

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

                    Text(LocalizationKeys.CreateEvent.dateScreenTitle.localize())
                        .style(.body1)

                    DatePicker(LocalizationKeys.CreateEvent.dateRowDate.localize(),
                               selection: $viewModel.eventDate,
                               displayedComponents: .date)
                    .datePickerStyle(.graphical)
                    .tint(.claret)
                    .onChange(of: viewModel.eventDate) { _ in viewModel.validateEventDate() }

                    DatePicker(LocalizationKeys.CreateEvent.dateRowTime.localize(),
                               selection: $viewModel.eventTime,
                               displayedComponents: .hourAndMinute)
                    .tint(.claret)
                    .onChange(of: viewModel.eventTime) { _ in viewModel.validateEventDate() }

                    if let eventDateError = viewModel.eventDateError {
                        Text(eventDateError)
                            .style(.caption)
                    }

                    Toggle(LocalizationKeys.CreateEvent.fieldTitleJoinDeadline.localize(),
                           isOn: Binding(get: { viewModel.joinDeadlineEnabled },
                                         set: { viewModel.toggleJoinDeadline($0) }))
                    .tint(.claret)

                    if viewModel.joinDeadlineEnabled {
                        DatePicker(LocalizationKeys.CreateEvent.fieldTitleJoinDeadline.localize(),
                                   selection: $viewModel.joinDeadlineDate,
                                   displayedComponents: .date)
                        .datePickerStyle(.compact)
                        .tint(.claret)
                        .onChange(of: viewModel.joinDeadlineDate) { _ in viewModel.validateJoinDeadline() }

                        DatePicker(LocalizationKeys.CreateEvent.fieldTitleJoinDeadlineTime.localize(),
                                   selection: $viewModel.joinDeadlineTime,
                                   displayedComponents: .hourAndMinute)
                        .tint(.claret)
                        .onChange(of: viewModel.joinDeadlineTime) { _ in viewModel.validateJoinDeadline() }

                        if let joinDeadlineError = viewModel.joinDeadlineError {
                            Text(joinDeadlineError)
                                .style(.caption)
                        }
                    }

                    CustomButton(title: .constant(LocalizationKeys.CreateEvent.continueButton.localize()),
                                 buttonStyle: .primary,
                                 isDisabled: .constant(!viewModel.canProceedFromDateStep)) {
                        viewModel.goToLocationStep()
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
