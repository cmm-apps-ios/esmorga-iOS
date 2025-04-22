//
//  RegistrationConfirmView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/4/25.
//

import SwiftUI

struct RegistrationConfirmView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: RegistrationConfirmViewModel

    init(viewModel: RegistrationConfirmViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    enum AccessibilityIds {
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Image("confirm-header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.35) // 30% of the screen height
                        .clipped()
                    LazyVStack(alignment: .leading, spacing: 10) {
                        Text(LocalizationKeys.RegistrationConfirmation.title.localize())
                            .style(.heading1)
                            .padding(.top, 20)

                        Text(LocalizationKeys.RegistrationConfirmation.subtitle.localize())
                            .style(.body1)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)

                    LazyVStack(spacing: 16) {
                        CustomButton(title: $viewModel.primaryButton.title,
                                     buttonStyle: .primary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            print("Test")
                        }

                        CustomButton(title: $viewModel.secondaryButton.title,
                                     buttonStyle: .secondary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            print("Test")
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBar {
            dismiss()
        }
    }
}



