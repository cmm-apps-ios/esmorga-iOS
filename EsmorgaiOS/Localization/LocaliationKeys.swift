//
//  LocaliationKeys.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

class LocalizationKeys {

    enum EventListKeys {
        static let title: String = "event_list_title"
        static let loadingText: String = "event_list_loading_text"
        static let emptyEventListText: String = "event_list_empty_text"
        static let eventListErrorTitle: String = "event_list_error_title"
        static let eventListErrorSubtitle: String = "event_list_error_subtitle"
        static let eventListErrorButtonTitle: String = "event_list_error_button"
    }

    enum EventDetailsKeys {
        static let title: String = "event_details_title"
        static let locationTitle: String = "event_details_location_title"
        static let navigateButtonText: String = "navigate_button"
    }

    enum WelcomeScreen {
        static let primaryButtonText: String = "login_registration_button"
        static let secondaryButtonText: String = "enter_guest_button"
    }

    enum CommonKeys {
        static let noConnectionText: String = "no_internet_snackbar"
    }
}

class Localize {

    static func localize(key: String) -> String {
        NSLocalizedString(key, comment: key)
    }
}
