//
//  ErrorDialog.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 22/8/24.
//

import SwiftUI

struct ErrorDialog: View {

    @Environment(\.dismiss) private var dismiss
    struct Model: Equatable {

        static func ==(lhs: Model, rhs: Model) -> Bool {
            return lhs.image == rhs.image &&
            lhs.message == rhs.message &&
            lhs.buttonText == rhs.buttonText
        }

        let image: String
        let message: String
        let buttonText: String
        let handler: (() -> Void)?
    }

    let model: Model

    var body: some View {
        ZStack {
            Color.surface.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                Image(model.image)
                    .resizable()
                    .frame(width: 80, height: 80)

                Text(model.message)
                    .style(.heading1)
                Spacer()
                CustomButton(title: model.buttonText, buttonStyle: .primary) {
                    model.handler?()
                    dismiss()
                }
            }
            .padding(16)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "arrow.left")
                            .tint(.onSurface)
                    }
                }
            }
        }

    }
}
