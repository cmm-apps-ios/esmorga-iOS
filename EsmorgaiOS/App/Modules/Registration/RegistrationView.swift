//
//  RegistrationView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 27/8/24.
//

import SwiftUI

struct RegistrationView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: RegistrationViewModel

    @FocusState private var focusedField: RegisterModels.TextFieldType?

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(LocalizationKeys.Registration.title.localize())
                        .style(.heading1)
                        .padding(.top, 20)
                    LazyVStack(alignment: .leading, spacing: 10) {
                        ForEach(viewModel.textFields.indices, id: \.self) { index in
                            CustomTextField(text: $viewModel.textFields[index].text,
                                            caption: $viewModel.textFields[index].errorMessage,
                                            isProtected: viewModel.textFields[index].isProtected,
                                            title: viewModel.textFields[index].title,
                                            hint: viewModel.textFields[index].placeholder)
                            .onFocusChange { isFocused in
                                if !isFocused {
                                    viewModel.validateTextField(type: viewModel.textFields[index].type, checkIsEmpty: false)
                                }
                            }
                            .focused($focusedField, equals: viewModel.textFields[index].type)
                        }
                    }
                    CustomButton(title: LocalizationKeys.Buttons.createAccount.localize(),
                                 buttonStyle: .primary,
                                 isLoading: $viewModel.isLoading) {
                        viewModel.performRegistration()
                    }
                                 .padding(.top, 37)
                }
                .padding(.horizontal, 16)
            }
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

extension RegistrationView {

    private func focusPreviousField() {
        focusedField = focusedField.map {
            RegisterModels.TextFieldType(rawValue: $0.rawValue - 1) ?? .confirmPass
        }
    }

    private func focusNextField() {
        focusedField = focusedField.map {
            RegisterModels.TextFieldType(rawValue: $0.rawValue + 1) ?? .name
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
        return currentFocusedField.rawValue < RegisterModels.TextFieldType.allCases.count - 1
    }
}
