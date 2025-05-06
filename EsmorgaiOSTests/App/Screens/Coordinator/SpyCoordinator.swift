//
//  SpyCoordinator.swift
//  EsmorgaiOSTests
//
//  Created by Vidal Pérez, Omar on 12/9/24.
//

import Foundation
import SwiftUI
@testable import EsmorgaiOS

class SpyCoordinator: CoordinatorProtocol {

    var pushCalled: Bool = false
    var destination: Destination?
    var popCalled: Bool = false
    var popToRootCalled: Bool = false
    var openNavigationAppCalled: Bool = false

    func push(destination: Destination) {
        self.destination = destination
        pushCalled = true
    }

    func pop() {
        popCalled = true
    }

    func popToRoot() {
        popToRootCalled = true
    }

    @ViewBuilder
    func build(destination: Destination) -> some View {
        AnyView(EmptyView())
    }

    func openNavigationApp(_ method: DeepLinkModels.Method) {
        openNavigationAppCalled = true
    }
}
