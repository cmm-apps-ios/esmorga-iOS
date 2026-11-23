//
//  NotificationServiceManager.swift
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

    static let platformTag = "ios"

    private var pushListener: OneSignalPushListener?
    private var isInitialized = false

    private init() {}

    // MARK: - Configuration

    /// Pure tag mapping (xcconfig environment + app version -> OneSignal tags).
    /// Values must match the backend `APP_ENV` so QA and PROD subscriptions are
    /// separable in the OneSignal dashboard.
    static func buildTags(appEnvironment: String?, appVersion: String) -> [String: String] {
        var tags: [String: String] = [
            "platform": platformTag,
            "version": appVersion
        ]
        if let appEnvironment, !appEnvironment.isEmpty {
            tags["environment"] = appEnvironment
        }
        return tags
    }

    // MARK: - Initialization

    /// Initializes the OneSignal SDK, applies environment tags and starts
    /// listening for notifications. Call once during app launch, passing the
    /// launch options from `AppDelegate.application(_:didFinishLaunchingWithOptions:)`.
    ///
    /// The App ID comes from the xcconfig -> Info.plist configuration path
    /// (`kOneSignalAppID`). It is required: debug/CI builds assert when it is
    /// missing; release builds skip initialization instead of crashing the app.
    func initialize(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
        guard let appId = Bundle.oneSignalAppID else {
            assertionFailure("Missing OneSignal App ID (set ONE_SIGNAL_APP_ID in the active xcconfig)")
            return
        }

        #if DEBUG
        OneSignal.Debug.setLogLevel(.verbose)
        #endif

        OneSignal.initialize(appId, withLaunchOptions: launchOptions)

        OneSignal.User.addTags(Self.buildTags(appEnvironment: Bundle.appEnvironment,
                                              appVersion: Bundle.shortVersion))

        let listener = OneSignalPushListener(router: .shared)
        listener.register()
        pushListener = listener

        isInitialized = true
    }

    // MARK: - Permission

    /// Requests push permission only when the system status is still
    /// `notDetermined` (the SDK reports `canRequestPermission` as false once the
    /// user has answered). Denial never blocks the app; the fallback opens the
    /// system settings on subsequent product-side taps.
    func requestPushPermissionIfNeeded() {
        guard isInitialized else { return }
        guard OneSignal.Notifications.canRequestPermission else { return }
        OneSignal.Notifications.requestPermission({ accepted in
            #if DEBUG
            print("User accepted notifications: \(accepted)")
            #endif
        }, fallbackToSettings: true)
    }

    // MARK: - Identity

    /// External-ID hooks kept available for future targeted notifications.
    /// Never pass emails, phone numbers or access tokens as public tags.
    func login(externalId: String) {
        guard isInitialized else { return }
        OneSignal.login(externalId)
    }

    func logout() {
        guard isInitialized else { return }
        OneSignal.logout()
    }
}
