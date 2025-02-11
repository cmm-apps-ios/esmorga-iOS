//
//  EsmorgaiOSApp.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI

@main
struct EsmorgaiOSApp: App {
    
    init() {
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .surface
        navBarAppearance.backgroundEffect = nil
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
    }
    
    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTest") == nil {
                MainCoordinatorView()
                    .onOpenURL { url in
                        handleDeepLink(url)
                    }
            }
        }
    }
    private func handleDeepLink(_ url: URL) {
        print("Link oppened: \(url)")
    }
}
