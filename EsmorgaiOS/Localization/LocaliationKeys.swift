//
//  LocaliationKeys.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

class LocalizationKeys {

    enum EventList {
        static let title: String = "screen_event_list_title"
        static let loading: String = "screen_event_list_loading"
        static let empty: String = "screen_event_list_empty_text"
    }

    enum EventDetails {
        static let description: String = "screen_event_details_description"
        static let location: String = "screen_event_details_location"
    }

    enum Buttons {
        static let createAccount: String = "button_create_account"
        static let guest: String = "button_guest"
        static let login: String = "button_login"
        static let loginRegister: String = "button_login_register"
        static let navigate: String = "button_navigate"
        static let register: String = "button_register"
        static let retry: String = "button_retry"
    }

    enum TextField {

        enum Title {
            static let email: String = "field_title_email"
            static let lastName: String = "field_title_last_name"
            static let name: String = "field_title_name"
            static let password: String = "field_title_password"
            static let repeatPassword: String = "field_title_repeat_password"
        }

        enum InlineError {
            static let email: String = "inline_error_email"
            static let emailAlreadyUsed: String = "inline_error_email_already_used"
            static let lastName: String = "inline_error_last_name"
            static let name: String = "inline_error_name"
            static let password: String = "inline_error_password"
            static let passwordInvalid: String = "inline_error_password_invalid"
            static let passwordMismatch: String = "inline_error_password_mismatch"
            static let emptyField: String = "inline_error_empty_field"
        }

        enum Placeholders {
            static let password: String = "placeholder_password"
            static let confirmPassword: String = "placeholder_confirm_password"
            static let email: String = "placeholder_email"
            static let lastName: String = "placeholder_last_name"
            static let name: String = "placeholder_name"
        }
    }

    enum DefaultError {
        static let title: String = "default_error_title"
        static let titleExpanded: String = "default_error_title_expanded"
        static let body: String = "default_error_body"
    }

    enum Login {
        static let title: String = "screen_login_title"
    }

    enum Registration {
        static let title: String = "screen_registration_title"
    }

    enum Snackbar {
        static let noInternet: String = "snackbar_no_internet"
    }
}

extension String {

    func localize() -> String {
        NSLocalizedString(self, comment: self)
    }
}
