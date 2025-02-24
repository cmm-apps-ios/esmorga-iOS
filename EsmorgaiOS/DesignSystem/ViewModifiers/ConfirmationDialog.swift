//
//  ConfirmationDialog.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/2/25.
//

import SwiftUI

struct ConfirmationDialog: ViewModifier {

    @Binding var model: ConfirmationDialogView.Model

    func body(content: Content) -> some View {
        ZStack {
            content
            ConfirmationDialogView(model: $model)
        }
    }
}
