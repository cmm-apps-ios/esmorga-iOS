//
//  BaseView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 1/8/24.
//

import SwiftUI

struct BaseView<Content: View, ViewState:ViewStateProtocol, VM: BaseViewModel<ViewState>>: View {

    @ObservedObject var baseViewModel: VM
    private let content: Content
    private var bgColor: Color = .surface

    init(viewModel: VM, @ViewBuilder content: () -> Content) {
        _baseViewModel = ObservedObject(wrappedValue: viewModel)
        self.content = content()
    }

    var body: some View {
        ZStack {
            bgColor.edgesIgnoringSafeArea(.all)
            content
        }
    }
}

protocol ViewStateProtocol: Equatable {
    static var ready: Self { get }
}

class BaseViewModel<E: ViewStateProtocol>: ObservableObject {
    @Published var state: E = .ready

    func changeState(_ state: E) {
        DispatchQueue.main.async { [weak self] in
            if self?.state != state {
                self?.state = state
                debugPrint("State changed to \(state)")
            }
        }
    }
}
