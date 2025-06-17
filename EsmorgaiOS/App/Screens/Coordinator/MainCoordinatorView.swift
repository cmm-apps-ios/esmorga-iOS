//
//  MainCoordinatorView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import SwiftUI

struct MainCoordinatorView: View {
    @StateObject private var coordinator = MainCoordinator()
    @EnvironmentObject var deepLinkManager: DeepLinkManager

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(destination: .splash)
                .navigationDestination(for: Destination.self) { destination in
                    coordinator.build(destination: destination)
                }
        }
        .onChange(of: deepLinkManager.deepLink) { newDeepLink in
            guard let deepLink = newDeepLink else { return }
            switch deepLink {
            case .verification(let code):
                coordinator.push(destination: .activate(code: code))
            case .resetPassword(let code):
                coordinator.push(destination: .resetPassword(code: code))
            case .unknown:
                break
            }
            deepLinkManager.deepLink = nil
        }
    }
}

