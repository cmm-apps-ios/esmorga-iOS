//
//  LottieView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import Lottie
import SwiftUI

struct LottieView: UIViewRepresentable {

    let animation: Animation

    func updateUIView(_ uiView: UIViewType, context: Context) {
        // Needed to conform to protocol 'UIViewRepresentable'
    }

    func makeUIView(context: Context) -> Lottie.LottieAnimationView {
        let animationView = LottieAnimationView(name: animation.fileName)
        animationView.loopMode = animation.loopMode
        animationView.play()
        animationView.contentMode = .scaleAspectFit
        return animationView
    }
}

#Preview {
    LottieView(animation: .dancingPepe)
}
