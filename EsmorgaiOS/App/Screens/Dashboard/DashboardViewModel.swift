//
//  DashboardViewModel.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import Foundation

enum DashboardViewStates: ViewStateProtocol {
    case ready
}

class DashboardViewModel: BaseViewModel<DashboardViewStates> {
    @Published var selectedTab: Int = 0

    let barItems: [DashboardModels.BarItems] = [DashboardModels.BarItems(image: "magnifyingglass", text: LocalizationKeys.Dashboard.explore.localize()),
                                                DashboardModels.BarItems(image: "calendar", text: LocalizationKeys.Dashboard.myEvents.localize()),
                                                DashboardModels.BarItems(image: "person", text: LocalizationKeys.Dashboard.myProfile.localize())]
}
