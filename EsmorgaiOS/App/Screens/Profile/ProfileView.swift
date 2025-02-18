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
        //Most of them i dont need it?
        static let errorView: String = "MyEventsView.errorView" //To change
        static let title: String = "my_profile_title"
        static let name: String = "my_profile_name"
        static let email: String = "my_profile_email"
        static let options: String = "my_profile_options"
        static let changePassword: String = "my_profile_change_password"
        static let logout: String = "my_profile_logout"
        static let logoutPopupDescription: String = "my_profile_logout_pop_up_title"
        static let logoutPopupConfirm: String = "my_profile_logout_pop_up_confirm"
        static let logoutPopupCancel: String = "my_profile_logout_pop_up_cancel"
    }
    
    @StateObject var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    //Main view profile
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
                    await viewModel.checkLoginStatus(forceRefresh: false)
                }
            }
    }
    //LogOut view
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
    
    //LogIn view
    private func createProfileView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            createTitleView()
            Text("Profile View")
                .padding(.horizontal, 16)
        }
    }
    
    //Title func
    private func createTitleView() -> some View {
        Text(LocalizationKeys.Profile.title.localize())
            .style(.heading1)
            .accessibilityIdentifier(AccessibilityIds.title)
    }
}

/*
 #Preview {
 ProfileView()
 }
 */
