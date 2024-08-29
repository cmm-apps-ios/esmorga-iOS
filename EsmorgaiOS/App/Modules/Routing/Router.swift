//
//  Router.swift
//  RoutingExample
//
//  Created by Vidal Pérez, Omar on 7/8/24.
//

import SwiftUI

public class Router<Destination: Routable>: ObservableObject {
    /// Used to programatically control a navigation stack
    @Published public var path: [Destination] = []
    /// Used to present a view using a sheet
    @Published public var presentingSheet: Destination?
    /// Used to present a view using a full screen cover
    @Published public var presentingFullScreenCover: Destination?
    /// Used by presented Router instances to dismiss themselves
    @Published public var isPresented: Binding<Destination?>
    public var isPresenting: Bool {
        presentingSheet != nil || presentingFullScreenCover != nil
    }
    
    public init(isPresented: Binding<Destination?>) {
        self.isPresented = isPresented
    }
    
    /// Returns the view associated with the specified `Routable`
    @ViewBuilder public func view(for route: Destination) -> some View {
        route.viewToDisplay(router: router(routeType: route.navigationType))
    }
    
    /// Routes to the specified `Routable`.
    public func routeTo(_ route: Destination, shouldClean: Bool = false) {
        switch route.navigationType {
        case .push:
            push(route, cleanStack: shouldClean)
        case .sheet:
            presentSheet(route)
        case .fullScreenCover:
            presentFullScreen(route)
        }
    }
    
    // Pop to the root screen in our hierarchy
    public func popToRoot() {
        path = []
    }
    
    public func back(_ count: Int = 1) {
        guard count > 0 else { return }
        guard count <= path.count else {
            path = .init()
            return
        }
        path.removeLast(count)
    }
    
    func back(to destination: Destination) {
        // Check if the destination exists in the stack
        if let index = path.lastIndex(where: { $0 == destination }) {
            // Remove destinations above the specified destination
            path.truncate(to: index)
        }
    }
    
    // Dismisses presented screen or self
    public func dismiss() {
        if !path.isEmpty {
            path.removeLast()
        } else if presentingSheet != nil {
            presentingSheet = nil
        } else if presentingFullScreenCover != nil {
            presentingFullScreenCover = nil
        } else {
            isPresented.wrappedValue = nil
        }
    }

    private func push(_ appRoute: Destination, cleanStack: Bool) {
        path.append(appRoute)
        if cleanStack {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.path.removeFirst(self.path.count - 1)
            }
        }
    }
    
    private func presentSheet(_ route: Destination) {
        self.presentingSheet = route
    }
    
    private func presentFullScreen(_ route: Destination) {
        self.presentingFullScreenCover = route
    }
    
    // Return the appropriate Router instance based
    // on `NavigationType`
    private func router(routeType: NavigationType) -> Router {
        switch routeType {
        case .push:
            return self
        case .sheet:
            return Router(
                isPresented: Binding(
                    get: { self.presentingSheet },
                    set: { self.presentingSheet = $0 }
                )
            )
        case .fullScreenCover:
            return Router(
                isPresented: Binding(
                    get: { self.presentingFullScreenCover },
                    set: { self.presentingFullScreenCover = $0 }
                )
            )
        }
    }
}

extension Array {
    /// Truncates the array up to the specified index.
    ///
    /// This method mutates the original array, keeping the elements up to the given index.
    /// If the index is greater than the array's count, the array remains unchanged.
    ///
    /// - Parameter index: The index up to which the array should be truncated.
    ///
    /// Example Usage:
    /// ```
    /// var numbers = [1, 2, 3, 4, 5]
    /// numbers.truncate(to: 2)
    /// // numbers is now [1, 2, 3]
    /// ```
    mutating func truncate(to index: Int) {
        guard index < self.count && index >= 0 else {
            return
        }
        self = Array(self[..<Swift.min(index + 1, self.count)])
    }
}
