//
//  CustomButton.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 3/7/24.
//

import SwiftUI

struct CustomButton: View {
    @State var title = ""
    @State var buttonStyle = CustomButtonStyle.primary
    var action: (() -> Void)? = nil

    var body: some View {

        Button {
            action?()
        } label: {
            Text(title)
                .style(.button, textColor: buttonStyle.textColor)
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .buttonStyle(FilledButton(style: buttonStyle))
    }
}

#Preview {
    ForEach(ColorScheme.allCases, id: \.self) {
        CustomButton(title: "Primary Button",
                     buttonStyle: .secondary)
            .preferredColorScheme($0)
            .padding()
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
    }
}
