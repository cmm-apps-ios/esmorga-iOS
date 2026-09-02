//
//  EventAttendeesView.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

import SwiftUI

struct EventAttendeesView: View {
    
    @StateObject var viewModel: EventAttendeesViewModel
    @Environment(\.dismiss) private var dismiss

    init(viewModel: EventAttendeesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack {
                ForEach(0..<viewModel.attendeesNames.count, id: \.self) { i in
                    Text(viewModel.attendeesNames[i])
                }
            }
        }
        .navigationBar {
            dismiss()
        }
        .task {
            await viewModel.getEventAttendees()
        }
    }
    
}
