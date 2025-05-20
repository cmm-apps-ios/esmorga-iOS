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

        .onChange(of: deepLinkManager.verificationCode) { newCode in
            if let code = newCode {
                print("onChange con code:", newCode ?? "nil")
                coordinator.push(destination: .activate(code: code))
                deepLinkManager.verificationCode = nil
            }
        }
    }
}
