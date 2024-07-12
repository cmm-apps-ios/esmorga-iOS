//
//  View+Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

extension View {

    func snackbar(message: String,
                  isShowing: Binding<Bool>,
                  autodismiss: Bool = false) -> some View {
        self.modifier(Snackbar(message: message,
                               isShowing: isShowing,
                               config: .init(autodismiss: autodismiss)))
    }
}
