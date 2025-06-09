//
//  RecoverPasswordModels.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 9/6/25.
//

import Foundation

enum ResetPasswordModels {

    enum TextFieldType: Int, CaseIterable {
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
