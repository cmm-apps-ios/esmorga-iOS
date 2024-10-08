//
//  View+Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

extension View {

    func snackbar(model: Binding<SnackbarView.Model>) -> some View {
        self.modifier(Snackbar(model: model))
    }
}
