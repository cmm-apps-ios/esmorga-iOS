//
//  NetworkMonitor.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import Network
import Foundation

protocol NetworkMonitorProtocol {
    func startMonitoring()
    func stopMonitoring()
    var isConnected: Bool { get }
}

class NetworkMonitor: NetworkMonitorProtocol {

    static let shared = NetworkMonitor()

    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue.global(qos: .background)
    var isConnected = true

    private init() {
        startMonitoring()
    }

    deinit {
        stopMonitoring()
    }

    func startMonitoring() {
        monitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        monitor.start(queue: queue)
    }

    func stopMonitoring() {
        monitor.cancel()
    }
}
