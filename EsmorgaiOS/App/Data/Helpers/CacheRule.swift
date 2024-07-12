//
//  CacheRule.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 11/7/24.
//

import Foundation

class CacheRule {

    static let cacheTime: Int = 30

    static func shouldShowCache(date: Date?) -> Bool {

        guard let date else { return false }
        guard let minutesFromNow = Calendar.current.dateComponents([.minute],
                                                                   from: date,
                                                                   to: .now).minute else { return false }
        return minutesFromNow <= cacheTime
    }
}
