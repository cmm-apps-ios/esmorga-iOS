//
//  RecoverPasswordModels.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 3/6/25.
//

import Foundation

enum RecoverPasswordModels {

    struct TextFieldModel {
        var text: String {
            didSet {
                guard text != oldValue else { return }
                errorMessage = nil
            }
        }
        let title: String
        let placeholder: String
        var errorMessage: String?
    }

    struct Button {
        var title: String
        var isLoading: Bool
    }
}
