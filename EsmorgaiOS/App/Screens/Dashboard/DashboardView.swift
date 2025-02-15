//
//  DashboardView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 11/9/24.
//

import SwiftUI

struct  DashboardView: View {
    
    enum AccessibilityIds {
        static let bottomBar: String = "DashboardView.bottomBar"
        static let eventList: String = "DashboardView.eventList"
        static let myEvents: String = "DashboardView.myEvents"
        static let profile: String = "DashboardView.profile"
    }
    
    @StateObject var viewModel: DashboardViewModel
    
    init(viewModel: DashboardViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 0) {
                TabView(selection: $viewModel.selectedTab) {
                    EventListBuilder().build(coordinator: viewModel.coordinator)
                        .accessibilityIdentifier(AccessibilityIds.eventList)
                        .tag(0)
                    MyEventsBuilder().build(coordinator: viewModel.coordinator)
                        .accessibilityIdentifier(AccessibilityIds.myEvents)
                        .tag(1)
                    //  Text("Perfil Content")
                    ProfileBuilder().build(coordinator: viewModel.coordinator)
                        .accessibilityIdentifier(AccessibilityIds.profile)
                        .tag(2)
                }
                .transition(.slide)
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                BottomBar(selectedTab: $viewModel.selectedTab,
                          barItems: viewModel.barItems.enumerated().map { BottomBar.BottomBarItem(image: $0.element.image,
                                                                                                  text: $0.element.text,
                                                                                                  tag: $0.offset) })
                .accessibilityIdentifier(AccessibilityIds.bottomBar)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
