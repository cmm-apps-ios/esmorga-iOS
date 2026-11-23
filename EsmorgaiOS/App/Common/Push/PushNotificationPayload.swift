//
//  PushNotificationPayload.swift
//  EsmorgaiOS
//
//  Parses the shared push payload contract `{ type: "event-created", eventId }`
//  coming from OneSignal `additionalData` into a navigation intent. Pure logic,
//  no OneSignal imports, so it can be unit tested without SDK network state.
//

import Foundation

/// Navigation intents derived from a push notification. Keep these independent
/// from the OneSignal SDK types (adapter pattern, see OneSignalPushListener).
enum PushNotificationIntent: Equatable {
    case eventDetails(eventId: String)
}

enum PushNotificationPayloadDecoder {

    private static let typeKey = "type"
    private static let eventIdKey = "eventId"
    private static let eventCreatedType = "event-created"

    /// Decodes the shared payload contract. Unknown types, missing keys and
    /// blank/malformed IDs yield `nil` so callers can fall back safely.
    static func intent(from additionalData: [AnyHashable: Any]?) -> PushNotificationIntent? {
        guard let additionalData,
              let type = additionalData[typeKey] as? String,
              type == eventCreatedType,
              let rawEventId = additionalData[eventIdKey] as? String
        else { return nil }

        let eventId = rawEventId.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !eventId.isEmpty else { return nil }

        return .eventDetails(eventId: eventId)
    }
}
