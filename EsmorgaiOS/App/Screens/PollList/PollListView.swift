//
//  PollListView.swift
//  EsmorgaiOS
//
//  Created by Marcelo Moran on 23/9/26.
//

import SwiftUI

struct PollListView: View {

    @StateObject var viewModel: PollListViewModel

    init(viewModel: PollListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            ZStack {
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text(LocalizationKeys.PollList.title.localize())
                            .style(.heading1)
                            .padding(.horizontal, 16)
                            .padding(.bottom, 12)
                            .padding(.top, 20)

                        switch viewModel.state {
                        case .ready, .loading:
                            VStack(alignment: .leading, spacing: 12) {
                                Text(LocalizationKeys.PollList.loading.localize())
                                    .style(.heading2)
                                LoadingBar()
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 20)
                        case .loaded:
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
                        case .empty:
                            LazyVStack(spacing: 0) {
                                PollListCell(title: LocalizationKeys.PollList.empty.localize(),
                                             titleAlignment: .center)
                            }
                        case .error:
                            EmptyView()
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }
                .onAppear {
                    Task {
                        await viewModel.getPollList(forceRefresh: false)
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
        }
    }
}
