//
//  FirstAppearModifier.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 19/9/24.
//

import Foundation
import SwiftUI

public struct FirstAppearModifier: ViewModifier {

    private let action: () async -> Void
    @State private var hasAppeared = false

    public init(_ action: @escaping () async -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true
                await action()
            }
    }
}
