//
//  CustomTextField.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 22/8/24.
//

import SwiftUI

struct CustomTextField: View {

    @Binding var text: String
    @Binding var caption: String?
    @State var isProtected: Bool
    @State var title: String
    @State var hint: String

    @State private var isSecure: Bool = true
    @FocusState private var isFocused: Bool // Focus state

    init(text: Binding<String>,
         caption: Binding<String?>? = nil,
         isProtected: Bool = false,
         title: String, hint: String) {
        self._text = text
        self._caption = caption ?? .constant(nil)
        self.isProtected = isProtected
        self.title = title
        self.hint = hint
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .style(.body1)
            HStack {
                ZStack(alignment: .leading) {
                    if text.isEmpty {
                        Text(hint)
                            .style(.caption, textColor: .onSurface)
                            .padding()
                    }
                    if isProtected && isSecure {
                        SecureField("", text: $text)
                            .focused($isFocused)
                            .frame(minHeight: 22)
                            .padding()
                    } else {
                        TextField("", text: $text)
                            .focused($isFocused)
                            .frame(minHeight: 22)
                            .padding()
                    }
                }

                if isProtected {
                    Button(action: {
                        isSecure.toggle()
                    }) {
                        Image(systemName: isSecure ? "eye" : "eye.slash")
                            .foregroundColor(.onSurface)
                            .padding(.trailing)
                    }
                }
            }
            .background(.onPrimary)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.customPink, lineWidth: 1)
            )
            if let caption {
                Text(caption)
                    .style(.caption)
            }
        }
    }

    func onFocusChange(_ perform: @escaping (Bool) -> Void) -> some View {
        self.modifier(FocusChangeModifier(onFocusChange: perform))
    }
}

struct FocusChangeModifier: ViewModifier {
    @FocusState private var isFocused: Bool
    var onFocusChange: (Bool) -> Void

    func body(content: Content) -> some View {
        content
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                onFocusChange(newValue)
            }
    }
}
