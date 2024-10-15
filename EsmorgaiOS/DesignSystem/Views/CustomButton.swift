//
//  CustomButton.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI

struct CustomButton: View {
    @Binding var title: String
    @State var buttonStyle = CustomButtonStyle.primary
    @Binding var isLoading: Bool
    @Binding var isDisabled: Bool
    var action: (() -> Void)? = nil

    init(title: Binding<String>,
         buttonStyle: CustomButtonStyle = .primary,
         isLoading: Binding<Bool>? = nil,
         isDisabled: Binding<Bool>? = nil,
         action: (() -> Void)? = nil) {
        self._title = title
        self.buttonStyle = buttonStyle
        self._isLoading = isLoading ?? .constant(false)
        self._isDisabled = isDisabled ?? .constant(false)
        self.action = action
    }

    var body: some View {
        Button {
            if !isLoading {
                withAnimation(.none) {
                    action?()
                }
            }
        } label: {
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .frame(width: 14, height: 14)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .tint(buttonStyle.textColor)
            } else {
                Text(title)
                    .style(.button, textColor: buttonStyle.textColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
        }
        .buttonStyle(FilledButton(style: buttonStyle))
        .disabled(isLoading || isDisabled)
    }
}

enum CustomButtonStyle {
    case primary
    case secondary

    var backgroundColor: Color {
        switch self {
        case .primary: return .claret
        case .secondary: return .customPink
        }
    }

    var textColor: Color {
        switch self {
        case .primary: return .white
        case .secondary: return .onSurface
        }
    }
}

struct FilledButton: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled
    @State var style: CustomButtonStyle = .primary

    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .padding()
            .background(style.backgroundColor)
            .cornerRadius(8)
            .frame(maxWidth: .infinity, alignment: .center)
            .opacity(configuration.isPressed ? 0.7 : 1)
            .animation(.spring, value: configuration.isPressed)
    }
}
