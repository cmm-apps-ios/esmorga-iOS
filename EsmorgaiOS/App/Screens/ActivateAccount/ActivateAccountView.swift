//
//  ActivateAccountView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/5/25.
//

import Foundation

import SwiftUI

struct ActivateAccountView: View {

    @StateObject var viewModel: ActivateAccountViewModel

    init(viewModel: ActivateAccountViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    enum AccessibilityIds {

    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    Image("activate-header")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(maxWidth: .infinity)
                        .frame(height: UIScreen.main.bounds.height * 0.35)
                        .clipped()
                    LazyVStack(alignment: .leading, spacing: 10) {
                        Text(LocalizationKeys.ActivateAccount.title.localize())
                            .style(.heading1)
                            .padding(.top, 20)
                        Text(LocalizationKeys.ActivateAccount.subtitle.localize())
                            .style(.body1)
                            .padding(.top, 20)
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 40)

                    LazyVStack(spacing: 16) {
                        CustomButton(title: $viewModel.primaryButton.title,
                                     buttonStyle: .primary,
                                     isLoading: $viewModel.primaryButton.isLoading) {
                            print("Hola")
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
