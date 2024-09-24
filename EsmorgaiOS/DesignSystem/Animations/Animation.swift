//
//  Animation.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import Lottie

enum Animation {
    case suspiciousMonkey
    case dancingPepe

    var fileName: String {
        switch self {
        case .suspiciousMonkey: return "suspiciousMonkey.json"
        case .dancingPepe: return "dancingPepe.json"
        }
    }

    var loopMode: Lottie.LottieLoopMode {
        switch self {
        case .suspiciousMonkey: return .loop
        case .dancingPepe: return .loop
        }
    }
}
