////
////  DashboardViewTests.swift
////  EsmorgaiOSTests
////
////  Created by Vidal Pérez, Omar on 13/9/24.
////
//
//import XCTest
//import ViewInspector
//import SwiftUI
//@testable import EsmorgaiOS
//
//final class DashboardViewTests: XCTestCase {
//
//    private var sut: DashboardView!
//    private var viewModel: DashboardViewModel!
//
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        viewModel = DashboardViewModel(coordinator: SpyCoordinator())
//        sut = DashboardView(viewModel: viewModel)
//    }
//
//    override func tearDownWithError() throws {
//        viewModel = nil
//        sut = nil
//        try super.tearDownWithError()
//    }
//
//    //MOB-TC-139
////    func test_given_dashboard_screen_when_tap_bar_item_show_correct_tab_view() throws {
////        var inspected = try sut.inspect()
////
////        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: DashboardView.AccessibilityIds.bottomBar))
////        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: DashboardView.AccessibilityIds.eventList))
////
////        viewModel.selectedTab = 1
////        inspected = try sut.inspect()
////
////        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: DashboardView.AccessibilityIds.myEvents))
////
////        viewModel.selectedTab = 2
////        inspected = try sut.inspect()
////
////        XCTAssertNoThrow(try inspected.find(viewWithAccessibilityIdentifier: DashboardView.AccessibilityIds.profile))
////    }
//
//    //MOB-TC-138
//    func test_given_dashboard_screen_has_correct_content() throws {
//        let inspected = try sut.inspect()
//        let baseView = try inspected.find(BaseView<AnyView, DashboardViewStates, DashboardViewModel>.self)
//        let bottomBar = try baseView.zStack().vStack(1).view(BottomBar.self, 1)
//
////        XCTAssertEqual(try bottomBar.accessibilityIdentifier(), DashboardView.AccessibilityIds.bottomBar)
//
//        let eventsItem = try bottomBar.find(viewWithAccessibilityIdentifier: BottomBar.AccessibilityIds.barItem + "0")
//        let eventsText = try eventsItem.button().labelView().vStack().text(1)
//        let eventsImage = try eventsItem.button().labelView().vStack().image(0)
//        XCTAssertEqual(try eventsText.string(), LocalizationKeys.Dashboard.explore.localize())
//        XCTAssertEqual(try eventsImage.actualImage().name(), "magnifyingglass")
//
//        let myEventsItem = try bottomBar.find(viewWithAccessibilityIdentifier: BottomBar.AccessibilityIds.barItem + "1")
//        let myEventsText = try myEventsItem.button().labelView().vStack().text(1)
//        let myEventsImage = try myEventsItem.button().labelView().vStack().image(0)
//        XCTAssertEqual(try myEventsText.string(), LocalizationKeys.Dashboard.myEvents.localize())
//        XCTAssertEqual(try myEventsImage.actualImage().name(), "calendar")
//
//        let profileItem = try bottomBar.find(viewWithAccessibilityIdentifier: BottomBar.AccessibilityIds.barItem + "2")
//        let profileText = try profileItem.button().labelView().vStack().text(1)
//        let profileImage = try profileItem.button().labelView().vStack().image(0)
//        XCTAssertEqual(try profileText.string(), LocalizationKeys.Dashboard.myProfile.localize())
//        XCTAssertEqual(try profileImage.actualImage().name(), "person")
//    }
//}
