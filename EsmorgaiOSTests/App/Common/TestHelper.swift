//
//  TestHelper.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/10/24.
//

import Foundation

class TestHelper {
    static func fullfillTask<T: Sendable>(operation: @escaping () async -> T) async -> T {
        let task = Task {
            await operation()
        }
        return await task.value
    }
}
