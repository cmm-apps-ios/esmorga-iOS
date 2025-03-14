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
                .fullScreenCover(isPresented: $model.isShown) {
                    ConfirmationDialogView(model: $model)
                        .background(ClearBackground())
                }
                .transaction { transaction in
                    transaction.disablesAnimations = true
                }
        }
    }
}

fileprivate struct ClearBackground: UIViewRepresentable {
    func makeUIView(context: Context) -> UIView {
        return DummyView()
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }

    private class DummyView: UIView {
        override func didMoveToWindow() {
            super.didMoveToWindow()
            superview?.superview?.backgroundColor = .clear
        }
    }
}
