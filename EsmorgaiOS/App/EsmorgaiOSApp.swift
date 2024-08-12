//
//  EsmorgaiOSApp.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI

@main
struct EsmorgaiOSApp: App {

//    init() {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground()
//        navBarAppearance.backgroundColor = .clear
//        navBarAppearance.backgroundEffect = nil
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
//    }

    var body: some Scene {
        WindowGroup {
            if NSClassFromString("XCTest") == nil {
                SplashView()
            }
        }
    }
}

enum Page: String, Identifiable {
    case list
    case details
    case events

    var id: String {
        self.rawValue
    }
}

enum FullScreen: String, Identifiable {
    case dialog

    var id: String {
        self.rawValue
    }
}




class SplashManager: ObservableObject {

    @Published var state: ViewState = .logged

    public enum ViewState {
        case logged
        case notlogged
    }
}




class Coordinator: ObservableObject {

    @Published var path = NavigationPath()
    @Published var fullScreen: FullScreen?

    func setRoot(_ page: Page) {
//        path = NavigationPath()
        path = NavigationPath()
        path.append(page)
        print("PATH: \(path)")
    }

    func push(_ page: Page) {
        path.append(page)
    }

    func present(fulScreen: FullScreen) {
        self.fullScreen = fulScreen
    }

    func pop() {
        path.removeLast()
    }

    func popToRoot() {
        path.removeLast(path.count)
    }

    func dismissFullscreen() {
        self.fullScreen = nil
    }

    @ViewBuilder
    func build(page: Page) -> some View {
//        switch page {
//        case .list:
//            EventListView()
//        case .details:
//            EventListView()
//        case .events:
            EventDetailsView(event: EventModels.Event(eventId: "12", name: "341234", date: .now, details: "sfasd", eventType: "asdf", imageURL: nil, latitude: nil, longitude: nil, location: "dfads", creationDate: .now))
//        }
    }

    @ViewBuilder
    func build(fullscreen: FullScreen) -> some View {
        switch fullscreen {
        case .dialog:
            build(page: .details)
//            EventListView()
        }
    }
}

struct CoordinatorView: View {

    @StateObject private var coordinator = Coordinator()
    

//    init() {
//        let navBarAppearance = UINavigationBarAppearance()
//        navBarAppearance.configureWithTransparentBackground()
//        navBarAppearance.backgroundColor = .clear
//        navBarAppearance.backgroundEffect = nil
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
//    }

    var body: some View {
        NavigationStack(path: $coordinator.path) {
            coordinator.build(page: .list)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
//                .fullScreenCover(item: $coordinator.fullScreen) { fullscreen in
//                    coordinator.build(fullscreen: fullscreen)
//                }
        }
        .environmentObject(coordinator)
    }
}

import SwiftUI

