//
//  TextStyles.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import Foundation
import SwiftUI

enum TextStyle {
    case title
    case heading1
    case heading2
    case body1
    case body1Accent
    case caption
    case button

    var size: CGFloat {
        switch self {
        case .title: return 32
        case .heading1: return 22
        case .heading2: return 18
        case .body1: return 16
        case .body1Accent: return 16
        case .caption: return 14
        case .button: return 14
        }
    }

    var kerning: CGFloat {
        switch self {
        case .title: return -0.8
        case .heading1: return -0.3
        case .heading2: return -0.27
        case .body1: return 0
        case .body1Accent: return 0
        case .caption: return 0
        case .button: return 0.2
        }
    }

    var lineSpacing: CGFloat {
        switch self {
        case .title: return 8
        case .heading1: return 5.5
        case .heading2: return 4.5
        case .body1: return 8
        case .body1Accent: return 8
        case .caption: return 7
        case .button: return 7
        }
    }

    var fontColor: Color {
        switch self {
        case .title, .heading1, .heading2, .body1, .button: return .onSurface
        case .body1Accent, .caption: return .onSurfaceVariant
        }
    }

    var fontName: String {
        switch self {
        case .title, .heading1, .heading2, .body1, .body1Accent: return "Plus Jakarta Sans"
        case .caption, .button: return "Epilogue"
        }
    }

    var fontWeight: Font.Weight {
        switch self {
        case .title: return .bold
        case .heading1: return .bold
        case .heading2: return .bold
        case .body1: return .regular
        case .body1Accent: return .light
        case .caption: return .light
        case .button: return .bold
        }
    }
}
