//
//  EventAttendeesView.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 02/09/2026.
//

import SwiftUI

struct EventAttendeesView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: EventAttendeesViewModel
    @State private var doesClose: Bool = false

    init(viewModel: EventAttendeesViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(alignment: .leading, spacing: 12) {
                title
                    .padding(.bottom, 16.5)
                    .padding(.top, 50)
                columnNames
                ScrollView {
                    VStack {
                        ForEach(0..<viewModel.attendeesNames.count, id: \.self) { i in
                            VStack(alignment: .center) {
                                Divider()
                                HStack(spacing: 0) {
                                    Text("\(i). \(viewModel.attendeesNames[i])")
                                        .style(.body1)
                                    Spacer()
                                    CheckBoxView(checked: $doesClose)
                                        .padding(.trailing, 15)
                                }
                                .padding(.vertical, 5)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .navigationBar {
            dismiss()
        }
        .task {
            await viewModel.getEventAttendees()
        }
    }
    
    var title: some View {
        Text(LocalizationKeys.Attendees.title.localize())
            .style(.heading1)
    }
    
    var columnNames: some View {
        HStack {
            Text(LocalizationKeys.Attendees.columnName.localize())
                .style(.heading2)
            Spacer()
            Text(LocalizationKeys.Attendees.columnPaid.localize())
                .style(.heading2)
        }
    }
    
}

#Preview {
    EventAttendeesView(viewModel: EventAttendeesViewModel(coordinator: MainCoordinator(), eventId: ""))
}
