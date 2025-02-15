//
//  ProfileView.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 15/2/25.
//

import SwiftUI

struct ProfileView: View {
    enum AccessibilityIds {
        //Unauth tags
        static let title: String = "bottom_bar_myprofile" //Uso este tag como 'title'
        static let unauthenticatedView: String = "unauthenticated_error_title"
        static let login: String = "button_login"
    }
    
    @StateObject var viewModel: ProfileViewModel
    
    init(viewModel: ProfileViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        Text("Mi perfil content...")
    }
}

/*
 #Preview {
 ProfileView()
 }
 */
