//
//  PollDetailsView.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 23/09/2026.
//

import SwiftUI

struct PollDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PollDetailsViewModel

    init(
        viewModel: PollDetailsViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    pollImage
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(viewModel.poll.name)
                            .style(.title)
                        
                        Text(LocalizationKeys.PollDetails.deadline.localize(formattedDeadline))
                        .style(.body1Accent)
                        .padding(.top, 8)
                        
                        Text(LocalizationKeys.PollDetails.information.localize())
                            .style(.heading1)
                            .padding(.top, 24)
                        
                        Text(viewModel.poll.description)
                            .style(.body1)
                            .padding(.top, 8)
                        
                        pollOptions
                            .padding(.top, 24)
                        
                        voteButton
                            .padding(.top, 24)
                    }
                    .padding(16)
                }
            }
        }
        .navigationBar {
            dismiss()
        }
    }

    @ViewBuilder
    private var pollImage: some View {
        //TODO: Implement this when imageURL on remote model
        /*
        if let imageURL = viewModel.poll.imageURL {
            AsyncImage(url: imageURL) { phase in
                switch phase {
                case .empty:
                    imagePlaceholder
                        .overlay {
                            ProgressView()
                        }

                case .success(let image):
                    image
                        .resizable()
                        .scaledToFill()

                case .failure:
                    imagePlaceholder

                @unknown default:
                    imagePlaceholder
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 200)
            .clipped()
        } else {
            imagePlaceholder
        }
         */
        imagePlaceholder
    }

    private var imagePlaceholder: some View {
        Image("poll_placeholder")
            .resizable()
            .aspectRatio(16/9, contentMode: .fill)
    }

    @ViewBuilder
    private var pollOptions: some View {
        if viewModel.poll.isMultipleChoice {
            multipleChoiceOptions
        } else {
            singleChoiceOptions
        }
    }

    private var multipleChoiceOptions: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.customPink)

            ForEach(
                Array(viewModel.poll.options.enumerated()),
                id: \.element.id
            ) { index, option in
                Button {
                    viewModel.toggleOption(option.id)
                } label: {
                    HStack(spacing: 12) {
                        Text(optionText(option))
                            .style(.body1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                        
                        Image(
                            systemName: viewModel.currentSelection.contains(option.id)
                                ? "checkmark.square.fill"
                                : "square"
                        )
                        .foregroundStyle(
                            viewModel.currentSelection.contains(option.id)
                                ? Color.claret
                                : Color.secondary
                        )
                    }
                    .contentShape(Rectangle())
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isDeadlinePassed)

                if index < viewModel.poll.options.count - 1 {
                    Divider()
                        .overlay(Color.customPink)
                }
            }

            Divider()
                .overlay(Color.customPink)
        }
    }

    private var singleChoiceOptions: some View {
        VStack(spacing: 0) {
            ForEach(viewModel.poll.options, id: \.id) { option in
                Button {
                    viewModel.toggleOption(option.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(
                            systemName: viewModel.currentSelection.contains(option.id)
                                ? "largecircle.fill.circle"
                                : "circle"
                        )
                        .foregroundStyle(
                            viewModel.currentSelection.contains(option.id)
                                ? Color.claret
                                : Color.secondary
                        )

                        Text(optionText(option))
                            .style(.body1)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                    }
                    .contentShape(Rectangle())
                    .padding(.vertical, 12)
                }
                .buttonStyle(.plain)
                .disabled(viewModel.isDeadlinePassed)
            }
        }
    }

    private var voteButton: some View {
        CustomButton(title: $viewModel.model.voteButton.title,
                     buttonStyle: .primary,
                     isLoading: $viewModel.model.voteButton.isLoading,
                     isDisabled: $viewModel.model.voteButton.isDeadlinePassed) {
            Task {
                await viewModel.vote()
            }
        }
    }

    private var formattedDeadline: String {
        viewModel.poll.voteDeadline.formatted(
            date: .abbreviated,
            time: .shortened
        )
    }

    private func optionText(_ option: PollOption) -> String {
        LocalizationKeys.PollDetails.countVotes.localize(option.name, option.voteCount)
    }
}

#Preview("Single Choice") {
    NavigationStack {
        PollDetailsView(
            viewModel: PollDetailsViewModel(
                poll: Poll(
                    id: "1",
                    name: "Where should the next company event be held?",
                    description: "Vote for your preferred location for the upcoming company event.",
                    options: [
                        PollOption(
                            id: "opt1",
                            name: "Madrid",
                            voteCount: 12
                        ),
                        PollOption(
                            id: "opt2",
                            name: "Barcelona",
                            voteCount: 18
                        ),
                        PollOption(
                            id: "opt3",
                            name: "Valencia",
                            voteCount: 7
                        )
                    ],
                    voteDeadline: Calendar.current.date(
                        byAdding: .day,
                        value: 7,
                        to: .now
                    )!,
                    isMultipleChoice: false,
                    userSelectedOptions: ["opt2"]
                ),
                coordinator: MainCoordinator()
            )
        )
    }
}

#Preview("Multiple Choice") {
    NavigationStack {
        PollDetailsView(
            viewModel: PollDetailsViewModel(
                poll: Poll(
                    id: "2",
                    name: "Which activities should be included?",
                    description: "Select one or more activities you'd like to see during the event.",
                    options: [
                        PollOption(
                            id: "opt1",
                            name: "Escape Room",
                            voteCount: 15
                        ),
                        PollOption(
                            id: "opt2",
                            name: "Go Kart",
                            voteCount: 20
                        ),
                        PollOption(
                            id: "opt3",
                            name: "Bowling",
                            voteCount: 11
                        )
                    ],
                    voteDeadline: Calendar.current.date(
                        byAdding: .day,
                        value: 5,
                        to: .now
                    )!,
                    isMultipleChoice: true,
                    userSelectedOptions: ["opt1", "opt3"]
                ),
                coordinator: MainCoordinator()
            )
        )
    }
}

#Preview("Deadline Passed") {
    NavigationStack {
        PollDetailsView(
            viewModel: PollDetailsViewModel(
                poll: Poll(
                    id: "3",
                    name: "Past Poll",
                    description: "Voting is closed for this poll.",
                    options: [
                        PollOption(
                            id: "opt1",
                            name: "Option A",
                            voteCount: 10
                        ),
                        PollOption(
                            id: "opt2",
                            name: "Option B",
                            voteCount: 8
                        )
                    ],
                    voteDeadline: Calendar.current.date(
                        byAdding: .day,
                        value: -1,
                        to: .now
                    )!,
                    isMultipleChoice: false,
                    userSelectedOptions: []
                ),
                coordinator: MainCoordinator()
            )
        )
    }
}
