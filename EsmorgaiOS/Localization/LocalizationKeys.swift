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

    enum MyEventList {
        static let title: String = "screen_my_events_title"
        static let empty: String = "screen_my_events_empty_text"
        static let loading: String = "screen_event_list_loading"
    }

    enum EventDetails {
        static let description: String = "screen_event_details_description"
        static let location: String = "screen_event_details_location"
    }
    
    enum Profile {
        static let title: String = "my_profile_title"
        static let name: String = "my_profile_name"
        static let email: String = "my_profile_email"
        static let options: String = "my_profile_options"
        static let changePassword: String = "my_profile_change_password"
        static let logout: String = "my_profile_logout"
        static let logoutPopupDescription: String = "my_profile_logout_pop_up_title"
        static let logoutPopupConfirm: String = "my_profile_logout_pop_up_confirm"
        static let logoutPopupCancel: String = "my_profile_logout_pop_up_cancel"
    }

    enum Common {
        static let unauthenticatedTitle: String = "unauthenticated_error_title"
    }

    enum Buttons {
        static let createAccount: String = "button_create_account"
        static let guest: String = "button_guest"
        static let login: String = "button_login"
        static let loginRegister: String = "button_login_register"
        static let confirmEmail: String = "register_confirmation_email_button_email_app"
        static let resendEmail: String = "register_confirmation_email_button_resend"
        static let navigate: String = "button_navigate"
        static let register: String = "button_register"
        static let retry: String = "button_retry"
        static let joinEvent: String = "button_join_event"
        static let leaveEvent: String = "button_leave_event"
        static let loginToJoin: String = "button_login_to_join"
        static let ok: String = "button_ok"
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

    enum NoConnection {
        static let title: String = "screen_no_connection_title"
        static let body: String = "screen_no_connection_body"
    }

    enum Login {
        static let title: String = "screen_login_title"
    }

    enum Registration {
        static let title: String = "screen_registration_title"
    }

    enum RegistrationConfirmation {
         static let title: String = "register_confirmation_email_title"
         static let subtitle: String = "register_confirmation_email_subtitle"
         static let titleResendEmail: String = "register_resend_code_success"
         static let titleResendEmailFailed: String = "register_resend_code_error"
     }

    enum Snackbar {
        static let noInternet: String = "snackbar_no_internet"
        static let eventJoined: String = "snackbar_event_joined"
        static let eventLeft: String = "snackbar_event_left"
    }

    enum Dashboard {
        static let explore: String = "bottom_bar_explore"
        static let myEvents: String = "bottom_bar_myevents"
        static let myProfile: String = "bottom_bar_myprofile"
    }
}

extension String {

    func localize() -> String {
        NSLocalizedString(self, comment: self)
    }
}
