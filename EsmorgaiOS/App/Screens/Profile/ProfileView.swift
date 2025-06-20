//
//  ProfileView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import SwiftUI
import Lottie

struct ProfileView: View {
    enum AccessibilityIds {
        static let errorView: String = "ProfileView.errorView"
        static let profileView: String = "ProfileView.ready"
        static let title: String = "ProfileView.myProfileTitle"
        static let rowDataTitle: String = "ProfileView.rowDataTitle"
        static let rowDataValue: String = "ProfileView.rowDataValue"
        static let rowOptionTitle: String = "ProfileView.rowOptionTitle"
        static let rowOptionTitleSecondary: String = "ProfileView.rowOptionTitleSecondary"
        static let rowOptionImage: String = "ProfileView.rowOptionImage"
    }

    @StateObject var viewModel: ProfileViewModel

    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            Group {
                switch viewModel.state {
                case .ready:
                    createProfileView()
                case .loggedOut:
                    createErrorView(animation: viewModel.loggedOutModel.animation,
                                    title: viewModel.loggedOutModel.title,
                                    buttonText: $viewModel.loggedOutModel.buttonText,
                                    action: { viewModel.loginButtonTapped() })
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }.navigationBarBackButtonHidden(true)
            .onAppear {
                Task {
                    await viewModel.checkLoginStatus()
                }
            }
    }

    private func createErrorView(animation: Animation, title: String, buttonText: Binding<String>, action: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            createTitleView()
                .padding(.bottom, 12)
            VStack(alignment: .center, spacing: 0) {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Spacer()
                        LottieView(animation: animation)
                            .looping()
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(height: geometry.size.height * 0.3)
                        Text(title)
                            .style(.heading1)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                CustomButton(title: buttonText, buttonStyle: .primary, action: action)
            }
        }
        .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
        .accessibilityIdentifier(AccessibilityIds.errorView)
    }

    private func createProfileView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            createTitleView()
                .padding(.bottom , 35)
            VStack(alignment: .leading, spacing: 8) {
                if let model = viewModel.loggedModel {
                    ForEach(model.userSection.items) { item in
                        Text(item.title)
                            .style(.heading1)
                            .accessibilityIdentifier(AccessibilityIds.rowDataTitle + "Title" + "\(item.id)")
                        Text(item.value)
                            .style(.body1)
                            .padding(.bottom, 35)
                            .accessibilityIdentifier(AccessibilityIds.rowDataValue + "Value" + "\(item.id)")
                    }
                    Text(model.optionsSection.title)
                        .style(.heading1)
                        .padding(.bottom, 35)
                        .accessibilityIdentifier(AccessibilityIds.rowOptionTitle)
                    ForEach(model.optionsSection.items) { item in
                        EsmorgaRow(
                            title: item.title,
                            subtitle: item.subtitle,
                            textButton: item.textButton,
                            buttonAction: {
                                viewModel.optionTapped(type: item.type)
                            }
                        )
                        .padding(.bottom, 30)
                    }
                }
            }
            Spacer()
        }
        .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
        .accessibilityIdentifier(AccessibilityIds.profileView)
        .confirmationDialog(model: $viewModel.confirmationDialog)
    }

    private func createTitleView() -> some View {
        Text(LocalizationKeys.Profile.title.localize())
            .style(.heading1)
            .accessibilityIdentifier(AccessibilityIds.title)
    }
}
