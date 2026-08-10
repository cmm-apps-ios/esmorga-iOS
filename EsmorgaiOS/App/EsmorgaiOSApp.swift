//
//  EsmorgaiOSApp.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI
import Firebase
import FirebaseCrashlytics

import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

@Observable
class FlutterDependencies {
 let flutterEngine = FlutterEngine(name: "my flutter engine")
 init() {
   // Runs the default Dart entrypoint with a default Flutter route.
   flutterEngine.run()
   // Connects plugins with iOS platform code to this app.
   GeneratedPluginRegistrant.register(with: self.flutterEngine);
 }
}

@main
struct EsmorgaiOSApp: App {
      @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
      @StateObject var deepLinkManager = DeepLinkManager()
    @State var flutterDependencies = FlutterDependencies()


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
                    .environment(flutterDependencies)
                    .environmentObject(deepLinkManager)
                    .onOpenURL { url in
                        deepLinkManager.handle(url: url)
                    }
            }
        }
    }
}
