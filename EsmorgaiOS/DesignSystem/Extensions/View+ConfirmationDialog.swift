//
//  View+ConfirmationDialog.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/2/25.
//

import SwiftUI

extension View {
    func confirmationDialog(model: Binding<ConfirmationDialogView.Model>) -> some View {
        self.modifier(ConfirmationDialog(model: model))
    }
}
