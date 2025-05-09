//
//  RegistrationConfirmViewModelTests.swift
//  EsmorgaiOSTests
//
//  Created by Ares Armesto, Yago on 6/5/25.
//

import Foundation
import Testing
@testable import EsmorgaiOS



@Suite(.serialized)
final class RegistrationConfirmViewModelTests {
    private var sut: RegistrationConfirmViewModel!
    private var spyCoordinator: SpyCoordinator!
    private var mockNetworkMonitor: MockNetworkMonitor!
    private var mockMailManager: MockExternalAppsManager!


    init() {
        spyCoordinator = SpyCoordinator()
        mockNetworkMonitor = MockNetworkMonitor()
        sut = RegistrationConfirmViewModel(coordinator: spyCoordinator, networkMonitor: mockNetworkMonitor, email: "")
    }

    deinit {
        mockNetworkMonitor = nil
        spyCoordinator = nil
        sut = nil
    }

    @MainActor
    @Test
    func test_given_open_email_tapped_then_navigation_is_triggered() async {

        sut.openMailApp()

        #expect(self.spyCoordinator.openAppCalled == true)

    }

    @Test
    func test_given_open_email_button_tapped_when_more_than_one_method_then_alert_is_shown() { //Tengo problema, parece que si que era un bug

        mockMailManager.methods = [DeepLinkModels.Method(title: "Gmail", url: URL(string: "googlegmail://co?to=&subject=Subject&body=Body")!),
                                         DeepLinkModels.Method(title: "Outlook", url: URL(string: "ms-outlook://")!)]
        sut.openMailApp()

        #expect(self.sut.showMethodsAlert == true)
    }

}


