//
//  LocalEventsDataSourceTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class LocalEventsDataSourceTests: XCTestCase {

    private var sut: LocalEventsDataSource!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LocalEventsDataSource()
        sut.clearAll()
    }

    override func tearDownWithError() throws {
        sut.clearAll()
        sut = nil
        try super.tearDownWithError()
    }


    func tests_given_get_events_when_empty_cache_then_return_empty_result() async {

        await expect { self.sut.getEvents }.to(beEmpty())
    }

    func test_given_get_events_when_cache_data_then_return_events() async {

        let events = [EventBuilder().build()]

        try? await sut.saveEvents(events)

        await expect { self.sut.getEvents }.to(equal(events))
    }
}
