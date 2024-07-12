//
//  NetworkMonitor.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import Observation
import Network

@Observable
class NetworkMonitor {
    private let networkMonitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")
    var isConnected = true

    init() {
        self.isConnected = networkMonitor.currentPath.status == .satisfied
        networkMonitor.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
        }
        networkMonitor.start(queue: workerQueue)
    }
}
