//
//  BaseView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 1/8/24.
//

import SwiftUI

struct BaseView<Content: View, ViewState: ViewStateProtocol, VM: BaseViewModel<ViewState>>: View {

    @ObservedObject var baseViewModel: VM
    private let content: Content
    private var bgColor: Color = .surface

    init(viewModel: VM, 
         @ViewBuilder content: () -> Content) {
        _baseViewModel = ObservedObject(wrappedValue: viewModel)
        self.content = content()
    }

    var body: some View {
        ZStack {
            bgColor.edgesIgnoringSafeArea(.all)
            content
        }
        .snackbar(model: $baseViewModel.snackBar)
    }
}
