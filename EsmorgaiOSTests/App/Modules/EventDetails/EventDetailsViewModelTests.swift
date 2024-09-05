//
//  EventDetailsViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 13/8/24.
//

import Nimble
import XCTest
@testable import EsmorgaiOS

final class EventDetailsViewModelTests: XCTestCase {

    private var sut: EventDetailsViewModel!
    private var spyEventDetailsRouter: SpyEventDetailsRouter!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyEventDetailsRouter = SpyEventDetailsRouter()
        sut = EventDetailsViewModel(router: spyEventDetailsRouter)
    }

    override func tearDownWithError() throws {
        spyEventDetailsRouter = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_open_maps_button_tapped_then_router_is_called() {

        sut.openAppleMaps(latitude: 10, longitude: -7)

        expect(self.spyEventDetailsRouter.openNavigationAppCalled).toEventually(beTrue())
    }
}

final class SpyEventDetailsRouter: EventDetailsRouterProtocol {

    var openNavigationAppCalled: Bool = false

    func openNavigationApp(_ method: NavigationModels.Method) {
        openNavigationAppCalled = true
    }
}
