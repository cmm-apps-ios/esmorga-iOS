//
//  String+RegexValidation.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation

enum RegexCase: String {
    case userEmail = "^(?!.{101})[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$"
    case userPassword = "^(?=.*[a-zA-Z])(?=.*[0-9])(?=.*[!@#\\$%^&*()_+'\\-=+/<>]).{8,50}$"
    case userName = "^[a-zA-Z '\\-]{3,100}$"
}

extension String {

    func isValid(regexPattern: RegexCase) -> Bool {
        if let regex = try? NSRegularExpression(pattern: regexPattern.rawValue, options: .caseInsensitive),
           regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count)) > 0 {
            return true
        } else {
            return false
        }
    }
}
