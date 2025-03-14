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
        var id: String {title}
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
        var id: String {title}
        var title: String
        var image: String
        var type: OptionsItemType
    }

    enum OptionsItemType {
        case changePassword
        case closeSession
    }
}
