//
//  CacheRuleTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation
import Testing
@testable import EsmorgaiOS

@Suite
final class CacheRuleTests {

    @Test(arguments: [(date: nil, expectation: false),
                      (date: Date(), expectation: true),
                      (date: Calendar.current.currentDateAdding(minutes: -40), expectation: false),
                      (date: Calendar.current.currentDateAdding(minutes: 40), expectation: true)])
    func test_given_date_scenarios_for_cache_rule_then_return_correct_value(scenario: (date: Date?, expectation: Bool)) throws {
        let shouldCache = CacheRule.shouldShowCache(date: scenario.date)
        #expect(shouldCache == scenario.expectation)
    }
}

private extension Calendar {
    func currentDateAdding(minutes: Int) -> Date? {
        return self.date(byAdding: .minute, value: minutes, to: .now)
    }
}
