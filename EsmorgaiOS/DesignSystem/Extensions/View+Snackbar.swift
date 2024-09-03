//
//  View+Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

extension View {

    func snackbar(model: Binding<SnackbarView.ViewModel>) -> some View {
        self.modifier(Snackbar(viewModel: model))
    }
}
