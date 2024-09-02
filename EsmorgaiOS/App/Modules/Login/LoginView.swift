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
                                viewModel.validateEmailField()
                            }
                        }
                        CustomTextField(text: $viewModel.passTextField.text,
                                        caption: $viewModel.passTextField.errorMessage,
                                        isProtected: viewModel.passTextField.isProtected,
                                        title: viewModel.passTextField.title,
                                        hint: viewModel.passTextField.placeholder)
                        .onFocusChange{ isFocused in
                            if !isFocused {
                                viewModel.validatePassField()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 20)
                    LazyVStack(spacing: 16) {
                        CustomButton(title: LocalizationKeys.Buttons.login.localize(),
                                     buttonStyle: .primary,
                                     isLoading: $viewModel.isLoading) {
                                viewModel.performLogin()
                        }
                        CustomButton(title: LocalizationKeys.Buttons.createAccount.localize(),
                                     buttonStyle: .secondary,
                                     isDisabled: $viewModel.isLoading) {
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
    }
}
