//
//  LocaliationKeys.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

class LocaliationKeys {

    enum EventListKeys {
        static let title: String = "event_list_title"
        static let loadingText: String = "event_list_loading_text"
        static let emptyEventListText: String = "event_list_empty_text"
        static let eventListErrorTitle: String = "event_list_error_title"
        static let eventListErrorSubtitle: String = "event_list_error_subtitle"
        static let eventListErrorButtonTitle: String = "event_list_error_button"
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
