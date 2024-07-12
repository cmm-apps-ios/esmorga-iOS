//
//  Snackbar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 12/7/24.
//

import SwiftUI

struct Snackbar: ViewModifier {

    let message: String
    @Binding var isShowing: Bool
    let config: Config

    func body(content: Content) -> some View {
        ZStack {
            content
            SnackbarView
        }
    }

    private var SnackbarView: some View {
        VStack {
            Spacer()
            if isShowing {
                Group {
                    Text(message)
                        .foregroundColor(config.textColor)
                        .font(config.font)
                        .padding(.vertical, 16)
                        .padding(.horizontal, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .background(config.backgroundColor)
                .cornerRadius(8)
                .onTapGesture {
                    isShowing = false
                }
                .onAppear {
                    if config.autoDismiss {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            isShowing = false
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 18)
        .animation(config.animation, value: isShowing)
        .transition(config.transition)
        .frame(maxWidth: .infinity)
    }

    struct Config {
        let textColor: Color
        let font: Font
        let backgroundColor: Color
        let transition: AnyTransition
        let animation: Animation
        let autoDismiss: Bool

        init(textColor: Color = .white,
             font: Font = .system(size: 14),
             backgroundColor: Color = .black.opacity(0.588),
             transition: AnyTransition = .opacity,
             animation: Animation = .linear(duration: 0.3),
             autodismiss: Bool) {
            self.textColor = textColor
            self.font = font
            self.backgroundColor = backgroundColor
            self.transition = transition
            self.animation = animation
            self.autoDismiss = autodismiss
        }
    }
}
