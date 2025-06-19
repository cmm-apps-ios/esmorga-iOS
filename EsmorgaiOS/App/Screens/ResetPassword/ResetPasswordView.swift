//
//  RecoverPasswordView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/6/25.
//

import Foundation

import SwiftUI

struct ResetPasswordView: View {

    @StateObject var viewModel: ResetPasswordViewModel
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: ResetPasswordModels.TextFieldType?
    init(viewModel: ResetPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }



    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 12) {
                createTitleView()
                    .padding(.bottom, 16.5)
                    .padding(.top, 50)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.textFields.indices, id: \.self) { index in
                        CustomTextField(text: $viewModel.textFields[index].text,
                                        caption: $viewModel.textFields[index].errorMessage,
                                        isProtected: viewModel.textFields[index].isProtected,
                                        title: viewModel.textFields[index].title,
                                        hint: viewModel.textFields[index].placeholder)
                        .onFocusChange { isFocused in
                            if !isFocused {
                                viewModel.validateTextField(type: viewModel.textFields[index].type, checkIsEmpty: true)
                            }
                        }
                        .focused($focusedField, equals: viewModel.textFields[index].type)
                    }
                }
                .padding(.bottom, 32)
                LazyVStack(spacing: 16) {
                    CustomButton(title: $viewModel.primaryButton.title,
                                 buttonStyle: .primary,
                                 isLoading: $viewModel.primaryButton.isLoading,
                                 isDisabled: .constant(!viewModel.isFormValid)) {
                        viewModel.performResetPassword()
                    }
                }
                Spacer()
            }
            .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .navigationBarBackButtonHidden(true)
    }
}

private func createTitleView() -> some View {
    Text(LocalizationKeys.ResetPassword.title.localize())
        .style(.heading1)
}

extension ResetPasswordView {

    private func focusPreviousField() {
        focusedField = focusedField.map {
            ResetPasswordModels.TextFieldType(rawValue: $0.rawValue - 1) ?? .confirmPass
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
        return currentFocusedField.rawValue <  ResetPasswordModels.TextFieldType.allCases.count - 1
    }
}
