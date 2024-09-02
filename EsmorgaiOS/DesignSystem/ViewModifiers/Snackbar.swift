//
//  Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/8/24.
//

import SwiftUI

struct Snackbar: ViewModifier {

    @Binding var viewModel: SnackbarView.ViewModel

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView(viewModel: $viewModel)
        }
    }
}
