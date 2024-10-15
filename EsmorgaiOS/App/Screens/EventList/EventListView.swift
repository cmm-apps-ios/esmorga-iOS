//
//  EventListView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 8/7/24.
//

import SwiftUI

struct EventListView: View {

    @StateObject var viewModel: EventListViewModel

    init(viewModel: EventListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(LocalizationKeys.EventList.title.localize())
                            .style(.heading1)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .padding(.top, 20)

                        switch viewModel.state {
                        case .ready, .loading:
                            VStack(alignment: .leading, spacing: 12) {
                                Text(LocalizationKeys.EventList.loading.localize())
                                    .style(.heading2)
                                LoadingBar()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        case .error:
                            VStack(alignment: .leading, spacing: 32) {
                                CardView(imageName: viewModel.errorModel.imageName,
                                         title: viewModel.errorModel.title,
                                         subtitle: viewModel.errorModel.subtitle)
                                CustomButton(title: $viewModel.errorModel.buttonText,
                                             buttonStyle: .primary) {
                                    Task {
                                        await viewModel.getEventList(forceRefresh: true)
                                    }
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
                                EventListCell(title: LocalizationKeys.EventList.empty.localize(),
                                              titleAlignment: .center)
                            }
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .onAppear {
                    Task {
                        await viewModel.getEventList(forceRefresh: false)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
