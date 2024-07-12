//
//  Text+TextStyle.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 9/7/24.
//

import SwiftUI

extension Text {

    func style(_ style: TextStyle, textColor: Color? = nil) -> some View {
        self.font(.custom(style.fontName, size: style.size))
            .fontWeight(style.fontWeight)
            .kerning(style.kerning)
            .lineSpacing(style.lineSpacing)
            .foregroundStyle(textColor ?? style.fontColor)
    }
}
