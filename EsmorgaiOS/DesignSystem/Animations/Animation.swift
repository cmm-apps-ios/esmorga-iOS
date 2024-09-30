//
//  Animation.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import Lottie
import SwiftUI

enum Animation {
    case suspiciousMonkey
    case dancingPepe

    var lottieAnimation: LottieAnimation? {
        switch self {
        case .suspiciousMonkey:
            return LottieAnimation.named("suspiciousMonkey")
        case .dancingPepe:
            return LottieAnimation.named("dancingPepe")
        }
    }
}

extension LottieView {

    init(animation: Animation) where Placeholder == EmptyView {
        self.init(animation: animation.lottieAnimation)
    }
}
