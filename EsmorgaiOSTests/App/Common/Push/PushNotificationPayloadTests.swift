//
//  PushNotificationPayloadTests.swift
//  EsmorgaiOSTests
//
//  Covers the shared push payload contract `{ type: "event-created", eventId }`:
//  decoding, unknown types, and blank/malformed ids must fail safely to nil.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
final class PushNotificationPayloadTests {

    @Test("valid event-created payload decodes to an event-details intent")
    func validPayload() {
        let intent = PushNotificationPayloadDecoder.intent(from: ["type": "event-created", "eventId": "abc-123"])
        #expect(intent == .eventDetails(eventId: "abc-123"))
    }

    @Test("event id is trimmed of surrounding whitespace")
    func trimmedEventId() {
        let intent = PushNotificationPayloadDecoder.intent(from: ["type": "event-created", "eventId": "  abc-123\n"])
        #expect(intent == .eventDetails(eventId: "abc-123"))
    }

    @Test("nil additionalData is ignored")
    func nilPayload() {
        #expect(PushNotificationPayloadDecoder.intent(from: nil) == nil)
    }

    @Test("unknown notification types are rejected")
    func unknownType() {
        let intent = PushNotificationPayloadDecoder.intent(from: ["type": "poll-created", "eventId": "abc"])
        #expect(intent == nil)
    }

    @Test("missing type or eventId keys are rejected")
    func missingKeys() {
        #expect(PushNotificationPayloadDecoder.intent(from: ["eventId": "abc"]) == nil)
        #expect(PushNotificationPayloadDecoder.intent(from: ["type": "event-created"]) == nil)
        #expect(PushNotificationPayloadDecoder.intent(from: [:] as [AnyHashable: Any]) == nil)
    }

    @Test("blank and whitespace-only event ids are rejected")
    func blankEventId() {
        #expect(PushNotificationPayloadDecoder.intent(from: ["type": "event-created", "eventId": ""]) == nil)
        #expect(PushNotificationPayloadDecoder.intent(from: ["type": "event-created", "eventId": "   \n "]) == nil)
    }

    @Test("non-string values are rejected")
    func malformedValues() {
        #expect(PushNotificationPayloadDecoder.intent(from: ["type": "event-created", "eventId": 42]) == nil)
        #expect(PushNotificationPayloadDecoder.intent(from: ["type": 7, "eventId": "abc"]) == nil)
    }
}
