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
        static let eventList: String = "SplashView.eventList"
    }

    @ObservedObject private var viewModel = SplashViewModel()
    init(viewModel: SplashViewModel = SplashViewModel()) {
        _viewModel = ObservedObject(wrappedValue: viewModel)
    }
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

    var body: some View {
        BaseView(viewModel: viewModel) {
            Group {
                switch viewModel.state {
                case .ready:
                    getLoadingView()
                        .accessibilityIdentifier(AccessibilityIds.loading)
                case .loggedOut:
                    getWelcomeRoutingView()
                        .accessibilityIdentifier(AccessibilityIds.welcome)
                        .transition(transition)
                case .loggedIn:
                    getEventListRoutingView()
                        .accessibilityIdentifier(AccessibilityIds.eventList)
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

    private func getEventListRoutingView() -> some View {
        RoutingView(MainRoute.self) { router in
            EventListBuilder().build(mainRouter: router)
        }
    }

    private func getWelcomeRoutingView() -> some View {
        RoutingView(MainRoute.self) { router in
            WelcomeScreenBuilder().build(mainRouter: router)
        }
    }
}
