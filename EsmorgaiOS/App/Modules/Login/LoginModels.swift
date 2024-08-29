//
//  LoginModels.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 26/8/24.
//

import Foundation

enum LoginModels {

    struct TextFieldModel {
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
}
