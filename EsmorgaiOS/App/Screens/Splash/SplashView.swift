//
//  SplashView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/8/24.
//

import SwiftUI

struct SplashView: View {

    enum AccessibilityIds {
        static let loading: String = "SplashView.loading"
        static let welcome: String = "SplashView.welcomeScreen"
        static let dashboard: String = "SplashView.dashboard"
    }

    @ObservedObject var viewModel: SplashViewModel
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

    init(viewModel: SplashViewModel) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            Group {
                switch viewModel.state {
                case .ready:
                    getLoadingView()
                        .accessibilityIdentifier(AccessibilityIds.loading)
                case .loggedOut:
                    WelcomeScreenBuilder().build(coordinator: viewModel.coordinator)
                        .accessibilityIdentifier(AccessibilityIds.welcome)
                        .transition(transition)
                case .loggedIn:
                    DashboardBuilder().build(coordinator: viewModel.coordinator)
                        .accessibilityIdentifier(AccessibilityIds.dashboard)
                        .transition(transition)
                }
            }
            .task {
                await viewModel.getUserStatus()
            }
            .animation(.default, value: viewModel.state)
        }
    }

    private func getLoadingView() -> some View {
        VStack {
            Spacer()
            Image("esmorga")
                .resizable()
                .aspectRatio(1/1, contentMode: .fill)
                .cornerRadius(16)
                .frame(width: 120, height: 120, alignment: .center)
                .padding(.bottom, 72)
            Spacer()
        }
    }
}

