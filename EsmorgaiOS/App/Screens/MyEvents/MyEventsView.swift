//
//  MyEventsView.swift
//  EsmorgaiOS
//
//  Created by Vidal Pérez, Omar on 23/9/24.
//

import SwiftUI
import Lottie

struct MyEventsView: View {

    enum AccessibilityIds {
        static let title: String = "MyEventsView.title"
        static let errorView: String = "MyEventsView.errorView"
        static let loadingView: String = "MyEventsView.loadingView"
        static let emptyView: String = "MyEventsView.emptyView"
        static let eventsList: String = "MyEventsView.eventsList"
    }

    @StateObject var viewModel: MyEventsViewModel

    init(viewModel: MyEventsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        BaseView(viewModel: viewModel) {
            Group {
                switch viewModel.state {
                case .ready, .loading:
                    createLoadingView()
                case .loaded:
                    createEventList()
                case .empty:
                    createEmptyView()
                case .error:
                    createErrorView(title: LocalizationKeys.DefaultError.title.localize(),
                                    buttonText: LocalizationKeys.Buttons.retry.localize(),
                                    action: { Task { await viewModel.retryButtonTapped() } })
                case .loggedOut:
                    createErrorView(title: LocalizationKeys.Common.unauthenticatedTitle.localize(),
                                    buttonText: LocalizationKeys.Buttons.login.localize(),
                                    action: { viewModel.loginButtonTapped() })
                }
            }.frame(maxWidth: .infinity, alignment: .leading)
                .onFirstAppear {
                    await viewModel.getEventList(forceRefresh: false)
                }
        }.navigationBarBackButtonHidden(true)
    }

    private func createErrorView(title: String, buttonText: String, action: @escaping (() -> Void)) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            createTitleView()
                .padding(.bottom, 12)
            VStack(alignment: .center, spacing: 0) {
                GeometryReader { geometry in
                    VStack(alignment: .center) {
                        Spacer()
                        LottieView(animation: .suspiciousMonkey)
                            .looping()
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(height: geometry.size.height * 0.3)
                        Text(title)
                            .style(.heading1)
                            .multilineTextAlignment(.center)
                        Spacer()
                    }.frame(maxWidth: .infinity, alignment: .center)
                }
                CustomButton(title: buttonText, buttonStyle: .primary, action: action)
            }
        }
        .padding(.init(top: 20, leading: 16, bottom: 16, trailing: 16))
        .accessibilityIdentifier(AccessibilityIds.errorView)
    }

    private func createTitleView() -> some View {
        Text(LocalizationKeys.MyEventList.title.localize())
            .style(.heading1)
            .accessibilityIdentifier(AccessibilityIds.title)
    }

    private func createLoadingView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            createTitleView()
                .padding(.bottom, 12)

            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKeys.EventList.loading.localize())
                    .style(.heading2)
                LoadingBar()
            }
        }
        .padding(.top, 20)
        .padding(.horizontal, 16)
        .accessibilityIdentifier(AccessibilityIds.loadingView)
    }

    private func createEmptyView() -> some View {
        VStack(alignment: .leading, spacing: 12) {
            createTitleView()
                .padding(.horizontal, 16)
            VStack(alignment: .leading, spacing: 12) {
                Text(LocalizationKeys.MyEventList.empty.localize())
                    .style(.heading1)
                    .padding(.horizontal, 16)
                GeometryReader { geometry in
                    VStack {
                        Spacer()
                        LottieView(animation: .dancingPepe)
                            .looping()
                            .resizable()
                            .aspectRatio(1/1, contentMode: .fit)
                            .frame(width: geometry.size.width * 0.7)
                    }
                }
            }
        }
        .padding(.top, 20)
        .accessibilityIdentifier(AccessibilityIds.emptyView)
    }

    private func createEventList() -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                createTitleView()
                    .padding(.horizontal, 16)
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
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityIdentifier(AccessibilityIds.emptyView)
    }
}
