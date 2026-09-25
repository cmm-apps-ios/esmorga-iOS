//
//  CreateEventTypeView.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

struct CreateEventTypeView: View {

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

                    Text(LocalizationKeys.CreateEvent.typeScreenTitle.localize())
                        .style(.body1)

                    VStack(spacing: 0) {
                        ForEach(EventType.allCases) { type in
                            Button {
                                viewModel.eventType = type
                            } label: {
                                HStack {
                                    Image(systemName: viewModel.eventType == type ? "largecircle.fill.circle" : "circle")
                                        .foregroundColor(.claret)
                                    Text(type.localizedName)
                                        .style(.body1)
                                    Spacer()
                                }
                                .padding(.vertical, 12)
                                .contentShape(Rectangle())
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }

                    CustomButton(title: .constant(LocalizationKeys.CreateEvent.continueButton.localize()),
                                 buttonStyle: .primary) {
                        viewModel.goToDateStep()
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
