//
//  CacheRuleTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class CacheRuleTests: XCTestCase {

    func test_given_date_scenarios_for_cache_rule_then_return_correct_value() throws {

        typealias Scenario = (date: Date?, matcher: Matcher<Bool>)

        let scenarios: [Scenario] = [(nil, beFalse()),
                                     (Date(), beTrue()),
                                     (getDateAdding(minutes: -40), beFalse()),
                                     (getDateAdding(minutes: 40), beTrue())]

        for scenario in scenarios {
            let shouldCache = CacheRule.shouldShowCache(date: scenario.date)
            expect(shouldCache).to(scenario.matcher)
        }
    }

    private func getDateAdding(minutes: Int) -> Date? {
        return Calendar.current.date(byAdding: .minute, value: minutes, to: .now)
    }
}
