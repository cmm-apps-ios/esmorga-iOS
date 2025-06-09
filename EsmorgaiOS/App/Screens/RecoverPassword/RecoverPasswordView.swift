//
//  RecoverPasswordView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 3/6/25.
//

import SwiftUI

struct RecoverPasswordView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: RecoverPasswordViewModel
    @FocusState private var focusedField: Field?

    init(viewModel: RecoverPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 12) {
                createTitleView()
                    .padding(.bottom, 16.5)
                VStack(alignment: .leading, spacing: 8) {
                    CustomTextField(text: $viewModel.emailTextField.text,
                                    caption: $viewModel.emailTextField.errorMessage,
                                    title: viewModel.emailTextField.title,
                                    hint: viewModel.emailTextField.placeholder)
                    .onFocusChange { isFocused in
                        if !isFocused {
                            viewModel.validateEmailField(checkIsEmpty: false)
                        }
                    }
                    .focused($focusedField, equals: .email)

                }
                .padding(.bottom, 32)
                LazyVStack(spacing: 16) {
                    CustomButton(title: $viewModel.primaryButton.title,
                                 buttonStyle: .primary,
                                 isDisabled: $viewModel.primaryButton.isLoading) {
                        viewModel.sendMailForgotPass()
                    }
                }
                Spacer()
            }
            .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBar {
            dismiss()
        }
    }
}

private func createTitleView() -> some View {
    Text(LocalizationKeys.forgotPassword.title.localize())
        .style(.heading1)
}

extension RecoverPasswordView {
    private enum Field: Int, CaseIterable {
        case email
    }

    private func focusNextField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue + 1) ?? .email
        }
    }

    private func canFocusPreviousField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue > 0
    }

    private func canFocusNextField() -> Bool {
        guard let currentFocusedField = focusedField else {
            return false
        }
        return currentFocusedField.rawValue < Field.allCases.count - 1
    }
}
