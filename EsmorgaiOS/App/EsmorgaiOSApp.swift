//
//  EsmorgaiOSApp.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI
import Firebase
import FirebaseCrashlytics

@main
struct EsmorgaiOSApp: App {
      @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
      @StateObject var deepLinkManager = DeepLinkManager()

    init() {
        FirebaseApp.configure()

        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        navBarAppearance.backgroundColor = .surface
        navBarAppearance.backgroundEffect = nil
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        FirstLaunchManager().setFirstLaunch()
    }

    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTest") == nil {
                MainCoordinatorView()
                    .environmentObject(deepLinkManager)
                    .onOpenURL { url in
                        deepLinkManager.handle(url: url)
                    }
            }
        }
    }
}
