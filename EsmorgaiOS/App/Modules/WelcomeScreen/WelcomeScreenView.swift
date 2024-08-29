//
//  WelcomeScreenView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import SwiftUI

struct WelcomeScreenView: View {
    @StateObject var viewModel: WelcomeScreenViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack {
                Spacer()
                Image("esmorga")
                    .resizable()
                    .aspectRatio(1/1, contentMode: .fill)
                    .frame(width: 120, height: 120, alignment: .center)
                    .padding(.bottom, 72)
                VStack(spacing: 48) {
                    CustomButton(title: Localize.localize(key: LocalizationKeys.WelcomeScreen.primaryButtonText),
                                 buttonStyle: .primary) {
                        viewModel.loginButtonTapped()
                    }
                    CustomButton(title: Localize.localize(key: LocalizationKeys.WelcomeScreen.secondaryButtonText),
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
