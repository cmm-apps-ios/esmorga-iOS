//
//  LocaliationKeys.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

class LocalizationKeys {

    enum EventList {
        static let title: String = "event_list_title"
        static let loadingText: String = "event_list_loading_text"
        static let emptyEventListText: String = "event_list_empty_text"
        static let eventListErrorTitle: String = "event_list_error_title"
        static let eventListErrorSubtitle: String = "event_list_error_subtitle"
        static let eventListErrorButtonTitle: String = "event_list_error_button"
    }

    enum EventDetails {
        static let title: String = "event_details_title"
        static let locationTitle: String = "event_details_location_title"
        static let navigateButtonText: String = "navigate_button"
    }

    enum WelcomeScreen {
        static let primaryButtonText: String = "login_registration_button"
        static let secondaryButtonText: String = "enter_guest_button"
    }

    enum Login {
        static let title: String = "login_screen_title"
        static let emailTitle = "login_screen_email"
        static let passwordTitle = "login_screen_password"
        static let buttonText = "login_button"
        static let createAccountText = "login_screen_create_account_button"
        static let emptyTextField = "login_empty_field"
        static let invalidEmailText = "login_email_invalid"
        static let invalidPasswordText = "login_password_invalid"
    }

    enum CommonKeys {
        static let noConnectionText: String = "no_internet_snackbar"
        static let errorTitle: String = "default_error_title"
        static let errorButtonText: String = "default_error_button"
    }
}

class Localize {

    static func localize(key: String) -> String {
        NSLocalizedString(key, comment: key)
    }
}
