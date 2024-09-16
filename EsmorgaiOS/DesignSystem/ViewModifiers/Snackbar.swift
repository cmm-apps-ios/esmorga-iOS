//
//  Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/8/24.
//

import SwiftUI

struct Snackbar: ViewModifier {

    @Binding var model: SnackbarView.Model

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView(model: $model)
        }
    }
}
