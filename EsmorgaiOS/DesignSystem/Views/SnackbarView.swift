//
//  Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

struct SnackbarView: View {

    struct Model {
        let message: String?
        var isShown: Bool
        let autoDismiss: Bool

        init(message: String? = nil, isShown: Bool = false, autoDismiss: Bool = true) {
            self.message = message
            self.isShown = isShown
            self.autoDismiss = autoDismiss
        }
    }

    @Binding var model: Model

    var body: some View {
        VStack {
            Spacer()
            if model.isShown {
                Group {
                    Text(model.message ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding(.all, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(.black.opacity(0.588))
                .cornerRadius(8)
                .onTapGesture {
                    model.isShown = false
                }
                .onAppear {
                    if model.autoDismiss {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            model.isShown = false
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .animation(.linear(duration: 0.3), value: model.isShown)
        .transition(.opacity)
        .frame(maxWidth: .infinity)
    }
}
