//
//  MockNetworkMonitor.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/9/24.
//

import Foundation
@testable import EsmorgaiOS

final class MockNetworkMonitor: NetworkMonitorProtocol {

    var mockIsConnected: Bool = true
    var startMonitoringIsCalled: Bool = false
    var stopMonitoringIsCalled: Bool = false

    func startMonitoring() {
        startMonitoringIsCalled = true
    }

    func stopMonitoring() {
        stopMonitoringIsCalled = true
    }

    var isConnected: Bool { mockIsConnected }
}
