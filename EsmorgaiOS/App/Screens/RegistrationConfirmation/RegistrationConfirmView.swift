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

        static let rowTitle: String = "RegistrationConfirmView.Title"
        static let rowSubTitle: String = "RegistrationConfirmView.Subtitle"
        static let rowButton: String = "RegistrationConfirmView.Button"
        static let rowButton2: String = "RegistrationConfirmView.Button2"
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Image("confirm-header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.35)
                        .clipped()
                    LazyVStack(alignment: .leading, spacing: 10) {
                        Text(LocalizationKeys.RegistrationConfirmation.title.localize())
                            .style(.heading1)
                            .padding(.top, 20)
                            .accessibilityIdentifier(AccessibilityIds.rowTitle)
                        Text(LocalizationKeys.RegistrationConfirmation.subtitle.localize())
                            .style(.body1)
                            .padding(.top, 20)
                            .accessibilityIdentifier(AccessibilityIds.rowSubTitle)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)

                    LazyVStack(spacing: 16) {
                        CustomButton(title: $viewModel.primaryButton.title,
                                     buttonStyle: .primary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            viewModel.openMailApp()
                        }
                                     .accessibilityIdentifier(AccessibilityIds.rowButton)

                        CustomButton(title: $viewModel.secondaryButton.title,
                                     buttonStyle: .tertiary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            viewModel.resendMail()
                        }
                                    .accessibilityIdentifier(AccessibilityIds.rowButton2)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .alert("Selecciona tu app de navigacion", isPresented: $viewModel.showMethodsAlert) {
            ForEach(viewModel.mailMethods, id: \.title) { method in
                Button(method.title) {
                    viewModel.openMailMethod(method)
                }
            }
            Button("Cancelar", role: .cancel) { }
        }
        .navigationBar {
            dismiss()
        }
    }
}
