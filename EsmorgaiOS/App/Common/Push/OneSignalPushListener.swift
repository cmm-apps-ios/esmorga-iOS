//
//  OneSignalPushListener.swift
//  EsmorgaiOS
//
//  The only place where OneSignal notification callbacks are touched. It owns
//  no navigation logic: payloads are decoded by PushNotificationPayloadDecoder
//  and handed to PushNotificationRouter, so behavior stays testable without the
//  SDK (see PushNotificationPayloadTests / PushNotificationRouterTests).
//

import Foundation
import OneSignalFramework

/// Holds OneSignal foreground and click callbacks with a lifetime that survives
/// the SwiftUI view lifecycle (retained by NotificationServiceManager).
final class OneSignalPushListener: NSObject, OSNotificationLifecycleListener, OSNotificationClickListener {

    private let router: PushNotificationRouter

    init(router: PushNotificationRouter) {
        self.router = router
        super.init()
    }

    // MARK: - Registration (ownership handled by NotificationServiceManager)

    func register() {
        OneSignal.Notifications.addForegroundLifecycleListener(self)
        OneSignal.Notifications.addClickListener(self)
    }

    func unregister() {
        OneSignal.Notifications.removeForegroundLifecycleListener(self)
        OneSignal.Notifications.removeClickListener(self)
    }

    // MARK: - OSNotificationLifecycleListener

    /// Foreground receipt. Default display is preserved (no `preventDefault`);
    //  any payload handling must stay side-effect free here.
    func onWillDisplay(event: OSNotificationWillDisplayEvent) {
        #if DEBUG
        print("OneSignal foreground notification: \(event.notification.notificationId)")
        #endif
    }

    // MARK: - OSNotificationClickListener

    /// Tap from foreground or background: OneSignal always reports the click,
    //  and navigation is guarded against duplicates by the router.
    func onClick(event: OSNotificationClickEvent) {
        guard let intent = PushNotificationPayloadDecoder.intent(from: event.notification.additionalData) else {
            #if DEBUG
            print("OneSignal click ignored: unknown or malformed payload")
            #endif
            return
        }
        Task { @MainActor in
            self.router.route(intent)
        }
    }
}
