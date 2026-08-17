//
//  MainCoordinatorView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import SwiftUI
import Flutter
// The following library connects plugins with iOS platform code to this app.
import FlutterPluginRegistrant

struct MainCoordinatorView: View {
    @StateObject private var coordinator = MainCoordinator()
    @EnvironmentObject var deepLinkManager: DeepLinkManager
    @Environment(FlutterDependencies.self) var flutterDependencies

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
        .task {
            listenFlutterMethodCalls()
        }
    }
    
    func listenFlutterMethodCalls() {
        let channel = FlutterMethodChannel(
            name: "my_app/navigation",
            binaryMessenger: flutterDependencies.flutterEngine.binaryMessenger
        )

        channel.setMethodCallHandler { call, result in
            switch call.method {

            case "openNativeScreen":
                let eventId = (call.arguments as? [String: Any])?["eventId"] as? String
                print("Flutter button tapped")
                coordinator.push(destination: .register)
                result(nil)

            default:
                result(FlutterMethodNotImplemented)
            }
        }
    }
}

