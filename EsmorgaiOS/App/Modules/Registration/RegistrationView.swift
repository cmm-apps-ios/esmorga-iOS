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
    }
}
