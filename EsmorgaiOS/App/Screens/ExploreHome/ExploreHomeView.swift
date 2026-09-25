//
//  ExploreHomeView.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 25/9/26.
//

import SwiftUI

struct ExploreHomeView: View {

    @StateObject var viewModel: ExploreHomeViewModel

    init(viewModel: ExploreHomeViewModel) {
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

                        content
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .onAppear {
                    Task {
                        await viewModel.load(forceRefresh: false)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .ready, .loading:
            loadingView
        case .loaded:
            sectionsView
        case .error:
            errorView
        }
    }

    private var loadingView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(LocalizationKeys.EventList.loading.localize())
                .style(.heading2)
            LoadingBar()
        }
        .padding(.horizontal, 16)
        .padding(.top, 20)
    }

    private var sectionsView: some View {
        VStack(alignment: .leading, spacing: 0) {
            eventsSection
            if viewModel.isUserLogged {
                pollsSection
            }
        }
    }

    private var eventsSection: some View {
        Group {
            if viewModel.events.isEmpty {
                EventListCell(title: LocalizationKeys.EventList.empty.localize(),
                              titleAlignment: .center)
            } else {
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
            }
        }
    }

    private var pollsSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            pollsTitle
            if viewModel.polls.isEmpty {
                LazyVStack(spacing: 0) {
                    PollListCell(title: LocalizationKeys.PollList.empty.localize(),
                                 titleAlignment: .center)
                }
            } else {
                LazyVStack(spacing: 0) {
                    ForEach(viewModel.polls, id: \.id) { poll in
                        Button {
                            viewModel.pollTapped(poll)
                        } label: {
                            PollListCell(title: poll.name,
                                         subtitle: poll.voteDeadline.string(format: .dayMonthHour),
                                         secondary: "")
                        }
                    }
                }
            }
        }
    }

    private var pollsTitle: some View {
        Text(LocalizationKeys.PollList.title.localize())
            .style(.heading1)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
            .padding(.top, 20)
    }

    private var errorView: some View {
        VStack(alignment: .leading, spacing: 32) {
            CardView(imageName: viewModel.errorModel.imageName,
                    title: viewModel.errorModel.title,
                    subtitle: viewModel.errorModel.subtitle)
            CustomButton(title: $viewModel.errorModel.buttonText,
                        buttonStyle: .primary) {
                Task {
                    await viewModel.retry()
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }.padding(16)
    }
}
