//
//  ProfileModels.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import Foundation

enum ProfileModels {
    struct ErrorModel {
        let animation: Animation
        let title: String
        var buttonText: String
    }

    struct LoggedModel {
        var userSection: UserData
        var optionsSection: Options
    }

    struct UserData {
        var items: [UserDataItem]
    }

    struct UserDataItem: Identifiable {
        var id: String { title }
        var title: String
        var value: String
        var type: UserDataItemType
    }

    enum UserDataItemType {
        case name
        case email
    }

    struct Options {
        var title: String
        var items: [OptionItem]
    }

    struct OptionItem: Identifiable {
        var id: String { title }
        var title: String
        var subtitle: String?      // <--- NUEVO
        var textButton: String?    // <--- NUEVO (antes era caption)
        var image: String?
        var type: OptionsItemType

        init(
            title: String,
            subtitle: String? = nil,
            textButton: String? = nil,
            image: String? = "arrow.right",
            type: OptionsItemType
        ) {
            self.title = title
            self.subtitle = subtitle
            self.textButton = textButton
            self.image = image
            self.type = type
        }
    }

    enum OptionsItemType {
        // case changePassword // Temporarily disabled
        case closeSession
    }
}
