//
//  NavigationBar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/8/24.
//

import SwiftUI

struct NavigationBar: ViewModifier {

    var dismiss: () -> Void

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
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
