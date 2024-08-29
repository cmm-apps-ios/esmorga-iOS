//
//  Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

struct Snackbar: ViewModifier {

    struct ViewModel {
        let message: String?
        var isShown: Bool
        let autoDismiss: Bool

        init(message: String? = nil, isShown: Bool = false, autoDismiss: Bool = true) {
            self.message = message
            self.isShown = isShown
            self.autoDismiss = autoDismiss
        }
    }

    @Binding var viewModel: ViewModel

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView
        }
    }

    private var SnackbarView: some View {
        VStack {
            Spacer()
            if viewModel.isShown {
                Group {
                    Text(viewModel.message ?? "")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding(.all, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(.black.opacity(0.588))
                .cornerRadius(8)
                .onTapGesture {
                    viewModel.isShown = false
                }
                .onAppear {
                    if viewModel.autoDismiss {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            viewModel.isShown = false
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .animation(.linear(duration: 0.3), value: viewModel.isShown)
        .transition(.opacity)
        .frame(maxWidth: .infinity)
    }
}
