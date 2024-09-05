//
//  SplashView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/8/24.
//

import SwiftUI

struct SplashView: View {

    @StateObject private var viewModel = SplashViewModel()
    let transition: AnyTransition = .asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading))

    var body: some View {
        BaseView(viewModel: viewModel) {
            Group {
                switch viewModel.state {
                case .loggedOut:
                    getEventListRoutingView()
                        .transition(transition)
                case .loggedIn, .ready:
                    Text("")
                }
            }
            .onAppear {
                viewModel.getUserStatus()
            }
            .animation(.default, value: viewModel.state)
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
