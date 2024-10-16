//
//  ErrorDialog.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 22/8/24.
//

import SwiftUI
import Lottie

struct ErrorDialog: View {

    @Environment(\.dismiss) private var dismiss
    struct Model: Equatable {

        static func ==(lhs: Model, rhs: Model) -> Bool {
            return lhs.animation == rhs.animation &&
            lhs.image == rhs.image &&
            lhs.primaryText == rhs.primaryText &&
            lhs.secondaryText == rhs.secondaryText &&
            lhs.buttonText == rhs.buttonText
        }

        let animation: Animation?
        let image: String?
        let primaryText: String
        let secondaryText: String?
        var buttonText: String
        let handler: (() -> Void)?
    }

    enum DialogType {
        case commonError
        case noInternet
    }

    @State var model: Model

    var body: some View {
        ZStack {
            Color.surface.edgesIgnoringSafeArea(.all)
            VStack(alignment: .center) {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Spacer()
                        if let animation = model.animation {
                            VStack(alignment: .center, spacing: 16) {
                                LottieView(animation: animation)
                                    .looping()
                                    .resizable()
                                    .aspectRatio(1/1, contentMode: .fit)
                                    .frame(width: geometry.size.width * 0.5)
                            }.frame(maxWidth: .infinity, alignment: .center)
                        }
                        if let image = model.image {
                            Image(image)
                                .resizable()
                                .frame(width: 80, height: 80)
                        }
                        VStack(alignment: .center, spacing: 10) {
                            Text(model.primaryText)
                                .style(.heading1)
                                .multilineTextAlignment(.center)
                            if let secondaryText = model.secondaryText {
                                Text(secondaryText)
                                    .style(.body1)
                                    .multilineTextAlignment(.center)
                            }
                        }
                        Spacer()
                    }
                }
                CustomButton(title: $model.buttonText, buttonStyle: .primary) {
                    model.handler?()
                    dismiss()
                }
            }
            .padding(16)
        }
        .navigationBarBackButtonHidden(true)
    }
}
