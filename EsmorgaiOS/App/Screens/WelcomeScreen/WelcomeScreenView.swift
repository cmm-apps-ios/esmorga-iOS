//
//  WelcomeScreenView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import SwiftUI

struct WelcomeScreenView: View {

    @StateObject var viewModel: WelcomeScreenViewModel

    init(viewModel: WelcomeScreenViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack {
                Spacer()
                Image(viewModel.model.imageName)
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fill)
                    .cornerRadius(16)
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding(.bottom, 72)
                VStack(spacing: 48) {
                    CustomButton(title: $viewModel.model.primaryButtonText,
                                 buttonStyle: .primary) {
                        viewModel.loginButtonTapped()
                    }
                    CustomButton(title: $viewModel.model.secondaryButtonText,
                                 buttonStyle: .secondary) {
                        viewModel.enterAsGuestTapped()
                    }
                }
                .padding(.horizontal, 26)
                Spacer()
            }
        }
    }
}
