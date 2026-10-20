//
//  OneSignalManager.swift
//  EsmorgaiOS
//
//  Created by Marcelo Morán on 19/10/26.
//

import Foundation
import OneSignalFramework

/// Single entry point for every OneSignal SDK interaction. All OneSignal calls
/// must go through this manager so the SDK stays isolated and easy to test.
final class NotificationServiceManager {

    static let shared = NotificationServiceManager()

    /// The OneSignal App ID used to initialize the SDK.
    /// TODO: Replace with the real 32-character App ID from the OneSignal
    /// dashboard (Settings -> Keys & IDs -> App ID).
    let appId: String = "0115e97b-297b-4eec-bd1a-130fe1e6a960"

    private init() {}

    /// Initializes the OneSignal SDK. Call once during app launch, passing the
    /// launch options from `AppDelegate.application(_:didFinishLaunchingWithOptions:)`.
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        OneSignal.initialize(appId, withLaunchOptions: launchOptions)
    }

    // MARK: - Push subscription (verification)

    /// Retain the observer for the lifetime of the view that creates it
    /// (OneSignal keeps observers weakly). The observer only fires once, and
    /// only for a real, server-assigned subscription ID.
    ///
    /// The subscription ID may already be assigned before the observer is
    /// attached, so it is evaluated both on change and immediately on add.
    func observePushSubscription(completion: @escaping () -> Void) -> PushSubscriptionObserver {
        let observer = PushSubscriptionObserver(completion: completion)
        OneSignal.User.pushSubscription.addObserver(observer)
        observer.evaluate(OneSignal.User.pushSubscription.id)
        return observer
    }

    /// Requests push permission. This is the only place permission is requested,
    /// and it happens only after the user taps the verification dialog button.
    func requestPushPermission() {
        OneSignal.Notifications.requestPermission({ accepted in
            #if DEBUG
            print("User accepted notifications: \(accepted)")
            #endif
        }, fallbackToSettings: true)
    }

    // MARK: - Identity / subscriptions / tags

    func login(externalId: String) {
        OneSignal.login(externalId)
    }

    func logout() {
        OneSignal.logout()
    }

    func addEmail(_ email: String) {
        OneSignal.User.addEmail(email)
    }

    func addSms(_ number: String) {
        OneSignal.User.addSms(number)
    }

    func addTag(key: String, value: String) {
        OneSignal.User.addTag(key: key, value: value)
    }

    // MARK: - Logging

    func setLogLevel(_ level: ONE_S_LOG_LEVEL) {
        OneSignal.Debug.setLogLevel(level)
    }
}

/// Observes push subscription changes and reports the current subscription ID
/// so the caller can confirm the device registered with OneSignal's servers.
final class PushSubscriptionObserver: NSObject, OSPushSubscriptionObserver {

    private let completion: () -> Void
    private var hasFired = false

    init(completion: @escaping () -> Void) {
        self.completion = completion
    }

    func onPushSubscriptionDidChange(state: OSPushSubscriptionChangedState) {
        evaluate(state.current.id)
    }

    /// Fires `completion` exactly once, and only when the subscription ID is a
    /// real, server-assigned value (non-empty and without the `local-` prefix).
    func evaluate(_ subscriptionId: String?) {
        guard Self.isRegistered(subscriptionId) else { return }
        DispatchQueue.main.async { [weak self] in
            guard let self = self, !self.hasFired else { return }
            self.hasFired = true
            self.completion()
        }
    }

    /// A real subscription ID is non-empty and not the `local-` placeholder the
    /// SDK assigns before the device registers with OneSignal.
    private static func isRegistered(_ subscriptionId: String?) -> Bool {
        guard let id = subscriptionId else { return false }
        return !id.isEmpty && !id.hasPrefix("local-")
    }
}
