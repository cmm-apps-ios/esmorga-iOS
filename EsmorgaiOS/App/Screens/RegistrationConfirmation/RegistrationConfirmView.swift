//
//  RegistrationConfirmView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 22/4/25.
//

import SwiftUI

struct RegistrationConfirmView: View {
    @StateObject var viewModel: RegistrationConfirmViewModel
    
    init(viewModel: RegistrationConfirmViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    enum AccessibilityIds {
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}



