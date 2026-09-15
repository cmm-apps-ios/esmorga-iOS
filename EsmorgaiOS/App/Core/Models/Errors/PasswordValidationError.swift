//
//  PasswordValidationError.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 03/09/2026.
//

import Foundation

enum PasswordValidationError: Equatable {
    case empty
    case invalidFormat
    case sameAsOldPassword
    case confirmationMismatch
    
    var messageError: String {

        switch self {
        case .empty:
            return LocalizationKeys.TextField.InlineError.emptyField.localize()

        case .invalidFormat:
            return LocalizationKeys.TextField.InlineError.passwordInvalidLong.localize()

        case .sameAsOldPassword:
            return LocalizationKeys.TextField.InlineError.passwordMustBeDifferent.localize()

        case .confirmationMismatch:
            return LocalizationKeys.TextField.InlineError.passwordMismatch.localize()
        }
    }
}
