//
//  RecoverPasswordView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 3/6/25.
//

import Foundation


import SwiftUI

struct RecoverPasswordView: View {

    @StateObject var viewModel: RecoverPasswordViewModel

    init(viewModel: RecoverPasswordViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    enum AccessibilityIds {

    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

