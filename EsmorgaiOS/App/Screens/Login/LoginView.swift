//
//  LoginView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 20/8/24.
//

import SwiftUI

struct LoginView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: LoginViewModel
    @FocusState private var focusedField: Field?

    init(viewModel: LoginViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Image("login-header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.3) // 30% of the screen height
                        .clipped()
                    LazyVStack(alignment: .leading, spacing: 10) {
                        Text(LocalizationKeys.Login.title.localize())
                            .style(.heading1)
                            .padding(.top, 20)
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
                        CustomTextField(text: $viewModel.passTextField.text,
                                        caption: $viewModel.passTextField.errorMessage,
                                        isProtected: viewModel.passTextField.isProtected,
                                        title: viewModel.passTextField.title,
                                        hint: viewModel.passTextField.placeholder)
                        .onFocusChange{ isFocused in
                            if !isFocused {
                                viewModel.validatePassField(checkIsEmpty: false)
                            }
                        }
                        .focused($focusedField, equals: .password)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    LazyVStack(spacing: 16) {
                        CustomButton(title: $viewModel.primaryButton.title,
                                     buttonStyle: .primary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            viewModel.performLogin()
                        }
                        Button(action: {
                            viewModel.navigateToRecoverPassword()
                        }) {
                            Text(LocalizationKeys.Buttons.forgotPassword.localize())
                                .style(.body1Accent)
                        }
                        .padding(.vertical, 12)
                        CustomButton(title: $viewModel.secondaryButton.title,
                                     buttonStyle: .secondary,
                                     isDisabled: $viewModel.primaryButton.isLoading) {
                            viewModel.navigateToRegister()
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer()
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBar {
            dismiss()
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()

                Button(action: focusPreviousField) {
                    Image(systemName: "chevron.up")
                }
                .disabled(!canFocusPreviousField()) // remove this to loop through fields
                Button(action: focusNextField) {
                    Image(systemName: "chevron.down")
                }
                .disabled(!canFocusNextField()) // remove this to loop through fields
            }
        }
    }
}

extension LoginView {
    private enum Field: Int, CaseIterable {
        case email, password
    }

    private func focusPreviousField() {
        focusedField = focusedField.map {
            Field(rawValue: $0.rawValue - 1) ?? .password
        }
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


