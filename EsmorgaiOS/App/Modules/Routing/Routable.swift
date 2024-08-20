//
//  Routable.swift
//  RoutingExample
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import SwiftUI

public enum NavigationType {
    case push
    case sheet
    case fullScreenCover
}

public protocol Routable: Hashable, Identifiable {
    associatedtype ViewType: View
    var navigationType: NavigationType { get }
    func viewToDisplay(router: Router<Self>) -> ViewType
}

extension Routable {
    public var id: Self { self }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

class Router2: ObservableObject {

    @Published var stack = [Route]()

    func push(to view: Route) {
        stack.append(view)
    }

    func pop() {
        stack.removeLast()
    }

    func popToRootView() {
        stack.removeAll()
    }
}

enum Route {
    case fooView
    case barView
}

extension Route: Hashable {}
