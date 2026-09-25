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
        static let attendeesInfo: String = "screen_event_details_attendees_info"
    }

    enum CreateEvent {
        static let title: String = "screen_create_event_title"
        static let typeScreenTitle: String = "create_event_type_screen_title"
        static let dateScreenTitle: String = "create_event_date_screen_title"

        static let fieldTitleName: String = "field_title_event_name"
        static let placeholderName: String = "placeholder_event_name"
        static let fieldTitleDescription: String = "field_title_event_description"
        static let placeholderDescription: String = "placeholder_event_description"
        static let fieldTitleLocation: String = "field_title_event_location"
        static let placeholderLocation: String = "placeholder_event_location"
        static let fieldTitleCoordinates: String = "field_title_event_coordinates"
        static let placeholderCoordinates: String = "placeholder_event_coordinates"
        static let fieldTitleMaxCapacity: String = "field_title_event_max_capacity"
        static let placeholderMaxCapacity: String = "placeholder_event_max_capacity"
        static let fieldTitleImage: String = "field_title_event_image"
        static let placeholderImage: String = "placeholder_event_image"
        static let fieldTitleJoinDeadline: String = "field_title_join_deadline"
        static let fieldTitleJoinDeadlineTime: String = "field_title_join_deadline_time"
        static let dateRowDate: String = "create_event_date_row_date"
        static let dateRowTime: String = "create_event_date_row_time"

        static let typeParty: String = "create_event_type_party"
        static let typeSport: String = "create_event_type_sport"
        static let typeFood: String = "create_event_type_food"
        static let typeCharity: String = "create_event_type_charity"
        static let typeGames: String = "create_event_type_games"

        static let continueButton: String = "step_continue_button"
        static let createButton: String = "button_create_event"
        static let previewButton: String = "button_preview"
        static let deleteButton: String = "button_delete"

        enum InlineError {
            static let invalidLengthName: String = "inline_error_invalid_length_name"
            static let invalidLengthDescription: String = "inline_error_invalid_length_description"
            static let locationRequired: String = "inline_error_location_required"
            static let locationInvalidChars: String = "inline_error_location_invalid_chars"
            static let coordinatesInvalid: String = "inline_error_coordinates_invalid"
            static let coordinatesOutOfBounds: String = "inline_error_coordinates_out_of_bounds"
            static let maxCapacityInvalid: String = "inline_error_max_capacity_invalid"
            static let imageUrlRequired: String = "inline_error_image_url_required"
            static let eventDatePast: String = "inline_error_event_date_past"
            static let eventTimePast: String = "inline_error_event_time_past"
            static let joinDeadlineExceeded: String = "inline_error_join_deadline_exceeded"
        }
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
        static let forgotPassword: String = "login_forgot_password"
        static let loginRegister: String = "button_login_register"
        static let confirmEmail: String = "register_confirmation_email_button_email_app"
        static let resendEmail: String = "register_confirmation_email_button_resend"
        static let continueVerify: String = "register_confirmation_button_continue"
        static let retryVerify: String = "register_confirmation_button_retry"
        static let navigate: String = "button_navigate"
        static let register: String = "button_register"
        static let forgotPasswordSend: String = "forgot_password_button"
        static let resetPassword: String = "reset_password_button"
        static let changePassword: String = "change_password_button"
        static let retry: String = "button_retry"
        static let joinEvent: String = "button_join_event"
        static let leaveEvent: String = "button_leave_event"
        static let loginToJoin: String = "button_login_to_join"
        static let seeAttendees: String = "button_see_attendees"
        static let ok: String = "button_ok"
        static let cancel: String = "register_confirmation_button_cancel"

    }

    enum TextField {

        enum Title {
            static let email: String = "field_title_email"
            static let lastName: String = "field_title_last_name"
            static let name: String = "field_title_name"
            static let password: String = "field_title_password"
            static let repeatPassword: String = "field_title_repeat_password"
            static let newPassword: String = "field_title_new_password"
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
            static let invalidCredentials: String = "invalid_credentials_error"
            static let passwordInvalidLong = "reset_password_invalid"
            static let passwordMustBeDifferent = "inline_error_password_must_be_different"
        }

        enum Placeholders {
            static let password: String = "placeholder_password"
            static let newPassword: String = "placeholder_new_password" //
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
     }

    enum ActivateAccount {
         static let title: String = "register_confirmation_title"
         static let subtitle: String = "register_confirmation_subtitle"
         static let errorTitle: String = "register_confirmation_error_title"
     }

    enum forgotPassword {
        static let title: String = "forgot_password_screen_title"
    }

    enum ResetPassword {
        static let title: String = "reset_password_screen_title"
    }
    
    enum Attendees {
        static let title: String = "attendees_screen_title"
        static let columnName: String = "attendees_screen_column_name"
        static let columnPaid: String = "attendees_screen_column_paid"
        static let butt: String = "attendees_screen_column_paid"
    }

    enum Snackbar {
        static let noInternet: String = "snackbar_no_internet"
        static let eventJoined: String = "snackbar_event_joined"
        static let eventLeft: String = "snackbar_event_left"
        static let resendEmail: String = "register_resend_code_success"
        static let resendEmailFailed: String = "register_resend_code_error"
        static let passwordReset: String = "forgot_password_snackbar_success"
        static let passwordChange: String = "password_set_snackbar" //
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
    
    func localize(_ arguments: CVarArg...) -> String{
       return String(format: self.localize(), arguments: arguments)
    }
}
