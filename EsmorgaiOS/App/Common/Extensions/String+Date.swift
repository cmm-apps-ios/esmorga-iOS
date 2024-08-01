//
//  String+Date.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 31/7/24.
//

import Foundation

extension String {

    func date(format: DateFormatter.Format) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        return dateFormatter.date(from: self)
    }
}

extension DateFormatter {

    enum Format: String {
        case iso8601 = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    }
}
