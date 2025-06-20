//
//  EsmorgaRow.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 19/6/25.
//

import SwiftUI

struct EsmorgaRow: View {
    var title: String
    var subtitle: String?
    var textButton: String?
    var buttonAction: (() -> Void)?

    init(
        title: String,
        subtitle: String? = nil,
        textButton: String? = nil,
        buttonAction: (() -> Void)? = nil
    ) {
        self.title = title
        self.subtitle = subtitle
        self.textButton = textButton
        self.buttonAction = buttonAction
    }

    var body: some View {
        Button(action: { buttonAction?() }) {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: subtitle == nil ? 0 : 2) {
                    Text(title)
                        .style(.heading2)
                        .padding(.bottom, 2)
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .style(.caption)
                    }
                }
                Spacer()
                if let textButton = textButton {
                    Text(textButton)
                        .style(.caption)
                }
                Image(systemName: "arrow.right")
                    .font(.system(size: 25, weight: .bold))
                    .foregroundColor(.claret)
            }
            .padding(.vertical, 12)
          //  .background(Color(.white))
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(buttonAction == nil)
    }
}

