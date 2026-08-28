//
//  ChangePasswordModels.swift
//  EsmorgaiOS
//
//  Created by Moran, Marcelo on 27/8/26.
//

import Foundation

enum ChangePasswordModels {

    enum TextFieldType: Int, CaseIterable {
        case oldPass
        case pass
        case confirmPass
    }

    struct TextFieldModels {
        let type: TextFieldType
        var text: String {
            didSet {
                guard text != oldValue else { return }
                errorMessage = nil
            }
        }
        let title: String
        let placeholder: String
        let isProtected: Bool
        var errorMessage: String?
    }

    struct Button {
        var title: String
        var isLoading: Bool
    }
}
