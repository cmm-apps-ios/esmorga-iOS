//
//  RegistrationModels.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 2/9/24.
//

import Foundation

enum RegisterModels {

    enum TextFieldType: Int, CaseIterable {
        case name
        case lastName
        case email
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

extension Array where Element == RegisterModels.TextFieldModels {
    mutating func resetAllTextFields() {
        for index in self.indices {
            self[index].text = ""
        }
    }
}
