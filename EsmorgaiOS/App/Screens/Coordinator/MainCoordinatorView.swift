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

    // OneSignal keeps push subscription observers weakly, so the observer must
    // be retained for the view's lifetime in @State or it is deallocated
    // immediately and the verification dialog never appears.
    @State private var showIntegrationCompleteAlert = false
    @State private var pushSubscriptionObserver: PushSubscriptionObserver?

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(destination: .splash)
                .navigationDestination(for: Destination.self) { destination in
                    coordinator.build(destination: destination)
                }
        }
        .onAppear {
            // The observer is created only once; re-appearing must not re-register,
            // and the verification dialog must be shown exactly once.
            guard pushSubscriptionObserver == nil else { return }
            let observer = OneSignalManager.shared.observePushSubscription {
                showIntegrationCompleteAlert = true
            }
            pushSubscriptionObserver = observer
        }
        .alert("Your OneSignal SDK integration is complete!", isPresented: $showIntegrationCompleteAlert) {
            Button("Got it") {
                OneSignalManager.shared.requestPushPermission()
            }
        } message: {
            Text("You can now send Push Notifications & In-App Messages through OneSignal. Tap below to enable push notifications.")
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
        // A forced logout (e.g. an expired session surfaced while creating an
        // event) must take the user back to Welcome instead of trapping them in
        // the retry dialog. The notification is posted from a background network
        // callback, so deliver it on the main thread before mutating navigation.
        .onReceive(NotificationCenter.default.publisher(for: .forceLogout).receive(on: DispatchQueue.main)) { _ in
            coordinator.handleForcedLogout()
        }
    }
}

