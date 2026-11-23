//
//  PushNotificationRouter.swift
//  EsmorgaiOS
//
//  Bridges push navigation intents into the root navigation flow. A tap can
//  arrive before the root navigation is ready (cold start), so intents are
//  retained until a delegate (the MainCoordinator) attaches, and then delivered
//  exactly once. SDK-free so the cold-start behavior is unit testable.
//

import Foundation

// Navigation is always funneled through the main thread (the OneSignal listener
// hops with `Task { @MainActor in ... }` and SwiftUI attaches from `onAppear`),
// matching the app's existing Swift 5 concurrency style.
protocol PushNavigationDelegate: AnyObject {
    func navigate(to intent: PushNotificationIntent)
}

final class PushNotificationRouter {

    static let shared = PushNotificationRouter()

    private weak var delegate: PushNavigationDelegate?
    /// Intent that arrived before the root navigation was ready. Consumed once
    /// on attach so a notification tap never navigates twice.
    private var pendingIntent: PushNotificationIntent?

    private init() {}

    /// Routes an intent immediately when navigation is ready, otherwise keeps it
    /// for delivery on attach. A newer intent replaces a stale pending one.
    func route(_ intent: PushNotificationIntent) {
        if let delegate {
            delegate.navigate(to: intent)
        } else {
            pendingIntent = intent
        }
    }

    /// Attaches the root navigation and flushes any pending intent exactly once.
    func attach(delegate: PushNavigationDelegate) {
        self.delegate = delegate
        guard let pendingIntent else { return }
        self.pendingIntent = nil
        delegate.navigate(to: pendingIntent)
    }

    /// Test seam: clears retained state between tests.
    func resetForTesting() {
        delegate = nil
        pendingIntent = nil
    }
}
