//
//  NotificationTagsTests.swift
//  EsmorgaiOSTests
//
//  Pure mapping between the xcconfig environment/version and the OneSignal
//  user tags (`environment`, `platform: ios`, `version`). The environment value
//  must match the backend APP_ENV so QA and PROD never share segments.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite(.serialized)
struct NotificationTagsTests {

    @Test("qa environment maps to the expected tag set")
    func qaTags() {
        let tags = NotificationServiceManager.buildTags(appEnvironment: "qa", appVersion: "2.1.0")
        #expect(tags["environment"] == "qa")
        #expect(tags["platform"] == "ios")
        #expect(tags["version"] == "2.1.0")
    }

    @Test("prod environment maps to the expected tag set")
    func prodTags() {
        let tags = NotificationServiceManager.buildTags(appEnvironment: "prod", appVersion: "2.1.0")
        #expect(tags["environment"] == "prod")
    }

    @Test("missing or empty environment omits the tag instead of sending a placeholder")
    func missingEnvironment() {
        let nilTags = NotificationServiceManager.buildTags(appEnvironment: nil, appVersion: "2.1.0")
        #expect(nilTags["environment"] == nil)
        #expect(nilTags["platform"] == "ios")

        let emptyTags = NotificationServiceManager.buildTags(appEnvironment: "", appVersion: "2.1.0")
        #expect(emptyTags["environment"] == nil)
    }
}
