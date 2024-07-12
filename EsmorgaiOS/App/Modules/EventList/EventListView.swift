//
//  EventListView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import SwiftUI

struct EventListView: View {

    @Environment(NetworkMonitor.self) private var networkMonitor: NetworkMonitor
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
                                         buttonStyle: .primary,
                                         action: viewModel.errorButtonAction)
                            .frame(maxWidth: .infinity, alignment: .center)
                        }.padding(16)
                    } else {
                        LazyVStack(spacing: 0) {
                            if !viewModel.events.isEmpty {
                                ForEach(viewModel.events) { event in
                                    EventListCell(imageUrl: event.imageURL,
                                                  title: event.name,
                                                  subtitle: event.date.description,
                                                  secondary: event.location)
                                }
                            } else {
                                EventListCell(title: Localize.localize(key: LocaliationKeys.EventListKeys.emptyEventListText),
                                              titleAlignment: .center)
                            }
                        }
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)

            }
            .background(.lavender)
            .task {
                if !networkMonitor.isConnected {
                    appManager.showSnackbarWith(text: Localize.localize(key: LocaliationKeys.CommonKeys.noConnectionText))
                }
                await viewModel.getEventList()
            }
            .onChange(of: networkMonitor.isConnected) { oldValue, newValue in
                if newValue {
                    appManager.hideToast()
                } else {
                    appManager.showSnackbarWith(text: Localize.localize(key: LocaliationKeys.CommonKeys.noConnectionText))
                }
            }
        }.snackbar(message: appManager.snackbarMessage, isShowing: $appManager.showSnackbar)
    }
}







