//
//  BottomBarSnapshotsTests.swift
//  EsmorgaiOSSnapshotTests
//
//  Created by Vidal Pérez, Omar on 13/9/24.
//

import XCTest
import SwiftUI
import SnapshotTesting
@testable import EsmorgaiOS

final class BottomBarSnapshotsTests: XCTestCase {

    func test_given_bottom_bar_item_with_tab_0_selected() {
        @State var selectedTab = 0

        let hostView = HostView {
            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab, barItems: givenBarItems())
            }
        }

        assertSnapshot(of: hostView.toVC(), as: .image)
    }

    func test_given_bottom_bar_item_with_tab_1_selected() {
        @State var selectedTab = 1

        let hostView = HostView {
            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab, barItems: givenBarItems())
            }
        }

        assertSnapshot(of: hostView.toVC(), as: .image)
    }

    func test_given_bottom_bar_item_with_tab_2_selected() {
        @State var selectedTab = 2

        let hostView = HostView {
            VStack {
                Spacer()
                BottomBar(selectedTab: $selectedTab, barItems: givenBarItems())
            }
        }

        assertSnapshot(of: hostView.toVC(), as: .image)
    }

    private func givenBarItems() -> [BottomBar.BottomBarItem] {
        return [BottomBar.BottomBarItem(image: "magnifyingglass", text: "Explore", tag: 0),
                BottomBar.BottomBarItem(image: "calendar", text: "My Events", tag: 1),
                BottomBar.BottomBarItem(image: "person", text: "Profile", tag: 2)]
    }
}

struct HostView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack {
            Color.surface
                .edgesIgnoringSafeArea(.all)
            content
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
