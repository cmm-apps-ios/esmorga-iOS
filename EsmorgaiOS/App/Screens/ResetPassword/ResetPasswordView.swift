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
    //  @FocusState private var focusedField: Field?
    init(viewModel: ResetPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }



    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 12) {
                createTitleView()
                    .padding(.bottom, 16.5)
                VStack(alignment: .leading, spacing: 8) {
                    ForEach(viewModel.textFields.indices, id: \.self) { index in
                        CustomTextField(text: $viewModel.textFields[index].text,
                                        caption: $viewModel.textFields[index].errorMessage,
                                        isProtected: viewModel.textFields[index].isProtected,
                                        title: viewModel.textFields[index].title,
                                        hint: viewModel.textFields[index].placeholder)
                    }
                }
                .padding(.bottom, 32)
                LazyVStack(spacing: 16) {
                    CustomButton(title: $viewModel.primaryButton.title,
                                 buttonStyle: .primary,
                                 isDisabled: $viewModel.primaryButton.isLoading) {
                        //  viewModel.sendMailForgotPass()
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
    Text("Cambia tu contraseña")
        .style(.heading1)
}


