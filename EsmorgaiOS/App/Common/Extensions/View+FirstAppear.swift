//
//  View+FirstAppear.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 19/9/24.
//

import SwiftUI

public extension View {
    func onFirstAppear(_ action: @escaping () async -> Void) -> some View {
        modifier(FirstAppearModifier(action))
    }
}
