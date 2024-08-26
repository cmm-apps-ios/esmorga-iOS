//
//  EventListView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import SwiftUI

struct EventListView: View {

    @StateObject var viewModel: EventListViewModel

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(Localize.localize(key: LocalizationKeys.EventList.title))
                            .style(.heading1)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .padding(.top, 20)

                        switch viewModel.state {
                        case .ready, .loading:
                            VStack(alignment: .leading, spacing: 12) {
                                Text(Localize.localize(key: LocalizationKeys.EventList.loadingText))
                                    .style(.heading2)
                                LoadingBar()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        case .error:
                            VStack(alignment: .leading, spacing: 32) {
                                CardView(imageName: "Alert",
                                         title: Localize.localize(key: LocalizationKeys.EventList.eventListErrorTitle),
                                         subtitle: Localize.localize(key: LocalizationKeys.EventList.eventListErrorSubtitle))
                                CustomButton(title: Localize.localize(key: LocalizationKeys.EventList.eventListErrorButtonTitle),
                                             buttonStyle: .primary) {
                                    viewModel.getEventList(forceRefresh: true)
                                }
                                             .frame(maxWidth: .infinity, alignment: .center)
                            }.padding(16)
                        case .loaded:
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.events) { event in
                                    Button {
                                        viewModel.eventTapped(event)
                                    } label: {
                                        EventListCell(imageUrl: event.imageURL,
                                                      title: event.name,
                                                      subtitle: event.date.string(format: .dayMonthHour),
                                                      secondary: event.location)
                                    }
                                }
                            }
                        case .empty:
                            LazyVStack(spacing: 0) {
                                EventListCell(title: Localize.localize(key: LocalizationKeys.EventList.emptyEventListText),
                                              titleAlignment: .center)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .onAppear {
                    viewModel.getEventList(forceRefresh: false)
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
