//
//  View+NavigationBar.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 30/8/24.
//

import SwiftUI

extension View {

    func navigationBar(backAction: @escaping () -> Void) -> some View {
        self.modifier(NavigationBar(dismiss: backAction))
    }
}
