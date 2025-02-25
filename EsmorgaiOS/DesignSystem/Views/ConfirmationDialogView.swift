//
//  ConfirmationDialogModel.swift
//  EsmorgaiOS
//
//  Created by Ares Armesto, Yago on 24/2/25.
//

import SwiftUI

struct ConfirmationDialogView: View {
    
    struct Model {
        var title: String?
        var isShown: Bool
        var primaryButtonTitle: String?
        var secondaryButtonTitle: String?
        var primaryAction: (() -> Void)?
        var secondaryAction: (() -> Void)?
        
        init(title: String? = nil, isShown: Bool = false, primaryButtonTitle: String? = nil, secondaryButtonTitle: String? = nil, primaryAction: (() -> Void)? = nil, secondaryAction: (() -> Void)? = nil) {
            self.title = title
            self.isShown = isShown
            self.primaryButtonTitle = primaryButtonTitle
            self.secondaryButtonTitle = secondaryButtonTitle
            self.primaryAction = primaryAction
            self.secondaryAction = secondaryAction
        }
    }
    
    @Binding var model: Model
    
    var body: some View {
        if model.isShown {
            ZStack {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        model.isShown = false
                    }
                
                VStack {
                    Text(model.title ?? "")
                        .font(.headline)
                        .padding()
                    HStack {
                        Button(action: {
                            model.isShown = false
                            model.primaryAction?()
                        }) {
                            Text(model.primaryButtonTitle ?? "")
                                .foregroundColor(.onPrimary)
                                .padding()
                                .background(Color.claret)
                                .cornerRadius(8)
                        }
                        Button(action: {
                            model.isShown = false
                            model.secondaryAction?()
                        }) {
                            Text(model.secondaryButtonTitle ?? "")
                                .foregroundColor(.black)
                                .padding()
                                .background(Color.customPink)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding()
                .background(Color.onPrimary)
                .cornerRadius(8)
                .shadow(radius: 10)
                .transition(.opacity)
            }
            .animation(.linear(duration: 0.3), value: model.isShown)
        }
    }
}
