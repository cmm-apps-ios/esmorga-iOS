//
//  MyEventsView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import SwiftUI

struct MyEventsView: View {
    @StateObject var viewModel: MyEventsViewModel

    init(viewModel: MyEventsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        BaseView(viewModel: viewModel) {
            Text("TODO in next us")
        }
    }
}
