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
    private var mockNavigationManager: MockNavigationManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        spyEventDetailsRouter = SpyEventDetailsRouter()
        mockNavigationManager = MockNavigationManager()
        sut = EventDetailsViewModel(router: spyEventDetailsRouter, navigationManager: mockNavigationManager)
    }

    override func tearDownWithError() throws {
        spyEventDetailsRouter = nil
        mockNavigationManager = nil
        sut = nil
        try super.tearDownWithError()
    }

    func test_given_open_maps_button_tapped_when_only_one_method_then_open_navigation_is_called() {

        sut.openLocation(latitude: 40.4165, longitude: -3.70256)

        expect(self.spyEventDetailsRouter.openNavigationAppCalled).toEventually(beTrue())
    }

    func test_given_open_maps_button_tapped_when_more_than_one_method_then_alert_is_shon() {

        mockNavigationManager.methods = [NavigationModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!),
                                         NavigationModels.Method(title: "Google Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

        sut.openLocation(latitude: 40.4165, longitude: -3.70256)

        expect(self.sut.showMethodsAlert).toEventually(beTrue())
    }
}

final class SpyEventDetailsRouter: EventDetailsRouterProtocol {

    var openNavigationAppCalled: Bool = false

    func openNavigationApp(_ method: NavigationModels.Method) {
        openNavigationAppCalled = true
    }
}

final class MockNavigationManager: NavigationManagerProtocol {

    var methods: [NavigationModels.Method] = [NavigationModels.Method(title: "Apple Maps", url: URL(string: "http://maps.apple.com/?saddr=&daddr=\(0.0),\(0.0)")!)]

    func getMethods(latitude: Double, longitude: Double) -> [NavigationModels.Method] {
        return methods
    }
}
