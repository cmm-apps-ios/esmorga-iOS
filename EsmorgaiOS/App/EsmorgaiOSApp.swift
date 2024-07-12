//
//  EsmorgaiOSApp.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI

@main
struct EsmorgaiOSApp: App {
    
    @State var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                EventListView()
                    .environment(networkMonitor)
            }
        }
    }
}
