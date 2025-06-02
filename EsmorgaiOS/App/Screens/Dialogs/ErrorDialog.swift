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
    @StateObject var viewModel: ErrorDialogViewModel

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
        let dialogType: DialogType
    }

    enum DialogType {
        case commonError
        case commonError2
        case expiredCode
        case noInternet
    }

    @State var model: Model


    var body: some View {
        ZStack {
            Color.surface.edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                VStack(alignment: .center, spacing: 16) {
                    if let animation = model.animation {
                        LottieView(animation: animation)
                            .looping()
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width * 0.45, height: UIScreen.main.bounds.width * 0.45) // no es exactamente lo mismo al geometry reader
                    } else if let image = model.image {
                        Image(image)
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
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
                CustomButton(title: $model.buttonText, buttonStyle: .primary) {
                    model.handler?()
                    if model.dialogType == .commonError2 {
                        viewModel.backToMain()
                    } else {
                        dismiss()
                    }
                }
                .padding(.bottom, 24)
            }
            .padding(16)
        }
        .navigationBarBackButtonHidden(true)
    }
}
