//
//  PushNotificationRouterTests.swift
//  EsmorgaiOSTests
//
//  Cold-start behavior: an intent that arrives before root navigation is ready
//  must be retained and delivered exactly once on attach.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@MainActor
final class SpyPushNavigationDelegate: PushNavigationDelegate {
    private(set) var received: [PushNotificationIntent] = []
    func navigate(to intent: PushNotificationIntent) {
        received.append(intent)
    }
}

@Suite(.serialized)
final class PushNotificationRouterTests {

    init() {
        PushNotificationRouter.shared.resetForTesting()
    }

    deinit {
        PushNotificationRouter.shared.resetForTesting()
    }

    @Test("intent routed while navigation is ready is delivered immediately")
    func routeWhenReady() {
        let router = PushNotificationRouter.shared
        let spy = SpyPushNavigationDelegate()
        router.attach(delegate: spy)

        router.route(.eventDetails(eventId: "1"))

        #expect(spy.received == [.eventDetails(eventId: "1")])
    }

    @Test("cold-start intent is retained and consumed once on attach")
    func coldStartIntentIsConsumedOnce() {
        let router = PushNotificationRouter.shared

        // Tap arrives before root navigation exists.
        router.route(.eventDetails(eventId: "42"))

        let spy = SpyPushNavigationDelegate()
        router.attach(delegate: spy)

        // Flushed on attach...
        #expect(spy.received == [.eventDetails(eventId: "42")])

        // ...and not replayed on a later attach (e.g. view re-appear).
        let laterSpy = SpyPushNavigationDelegate()
        router.attach(delegate: laterSpy)
        #expect(laterSpy.received.isEmpty)
    }

    @Test("a newer pending intent replaces a stale one")
    func pendingIntentReplaced() {
        let router = PushNotificationRouter.shared

        router.route(.eventDetails(eventId: "old"))
        router.route(.eventDetails(eventId: "new"))

        let spy = SpyPushNavigationDelegate()
        router.attach(delegate: spy)

        #expect(spy.received == [.eventDetails(eventId: "new")])
    }
}
