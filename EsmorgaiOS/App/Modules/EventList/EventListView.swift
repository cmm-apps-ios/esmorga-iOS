//
//  EventListView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import SwiftUI

struct EventListView: View {

    @StateObject private var viewModel = EventListViewModel()
    @StateObject private var appManager = AppManager.shared

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text(Localize.localize(key: LocaliationKeys.EventListKeys.title))
                        .style(.heading1)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 12)
                        .padding(.top, 20)
                    if viewModel.isLoading {
                        VStack(alignment: .leading, spacing: 12) {
                            Text(Localize.localize(key: LocaliationKeys.EventListKeys.loadingText))
                                .style(.heading2)
                            LoadingBar()
                        }
                        .padding(.horizontal, 16)
                        .padding(.top, 20)
                    } else if viewModel.hasError {
                        VStack(alignment: .leading, spacing: 32) {
                            CardView(imageName: "Alert",
                                     title: Localize.localize(key: LocaliationKeys.EventListKeys.eventListErrorTitle),
                                     subtitle: Localize.localize(key: LocaliationKeys.EventListKeys.eventListErrorSubtitle))
                            CustomButton(title: Localize.localize(key: LocaliationKeys.EventListKeys.eventListErrorButtonTitle),
                                         buttonStyle: .primary) {
                                viewModel.getEventList(forceRefresh: true)
                            }
                            .frame(maxWidth: .infinity, alignment: .center)
                        }.padding(16)
                    } else {
                        LazyVStack(spacing: 0) {
                            if !viewModel.events.isEmpty {
                                    ForEach(viewModel.events) { event in
                                        NavigationLink(destination: EventDetailsView()) {
                                        EventListCell(imageUrl: event.imageURL,
                                                      title: event.name,
                                                      subtitle: event.date.description,
                                                      secondary: event.location)
                                    }
                                }

                            } else {
                                EventListCell(title: Localize.localize(key: LocaliationKeys.EventListKeys.emptyEventListText),
                                              titleAlignment: .center)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)

            }
            .background(.surface)
            .onAppear {
                viewModel.getEventList(forceRefresh: false)
            }
        }.snackbar(message: Localize.localize(key: LocaliationKeys.CommonKeys.noConnectionText), isShowing: $viewModel.showSnackbar)
    }
}
