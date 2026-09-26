//
//  Untitled.swift
//  EsmorgaiOS
//
//  Created by marcelo.moran on 23/09/2026.
//

import SwiftUI

struct PollDetailsView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel: PollDetailsViewModel

    @State private var alertMessage: AlertMessage?

    init(
        viewModel: PollDetailsViewModel
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                pollImage

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewModel.poll.name)
                        .font(.largeTitle.bold())

                    Text(
                        "Voting deadline: \(formattedDeadline)"
                    )
                    .font(.body)
                    .foregroundStyle(.tint)
                    .padding(.top, 8)

                    Text("Information")
                        .font(.title2.bold())
                        .padding(.top, 24)

                    Text(viewModel.poll.description)
                        .font(.body)
                        .padding(.top, 8)

                    pollOptions
                        .padding(.top, 24)

                    voteButton
                        .padding(.top, 24)
                }
                .padding(16)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                }
                .accessibilityLabel("Back")
            }
        }
        .alert(item: $alertMessage) { message in
            Alert(
                title: Text(message.title),
                message: Text(message.message),
                dismissButton: .default(Text("OK")) {
                    viewModel.clearMessage()
                }
            )
        }
        .onChange(of: viewModel.voteState) { newState in
            handleVoteState(newState)
        }
    }

    @ViewBuilder
    private var pollImage: some View {
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
        Image("placeholder-esmorga")
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
                .overlay(Color.secondary)

            ForEach(
                Array(viewModel.poll.options.enumerated()),
                id: \.element.id
            ) { index, option in
                Button {
                    viewModel.toggleOption(option.id)
                } label: {
                    HStack(spacing: 12) {
                        Image(
                            systemName: viewModel.currentSelection.contains(option.id)
                                ? "checkmark.square.fill"
                                : "square"
                        )
                        .foregroundStyle(
                            viewModel.currentSelection.contains(option.id)
                                ? Color.accentColor
                                : Color.secondary
                        )

                        Text(optionText(option))
                            .foregroundStyle(.primary)
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

                if index < viewModel.poll.options.count - 1 {
                    Divider()
                        .overlay(Color.secondary)
                }
            }

            Divider()
                .overlay(Color.secondary)
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
                                ? Color.accentColor
                                : Color.secondary
                        )

                        Text(optionText(option))
                            .foregroundStyle(.primary)
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
        Button {
            Task {
                await viewModel.vote()
            }
        } label: {
            HStack {
                Spacer()

                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text(viewModel.buttonText)
                        .font(.headline)
                }

                Spacer()
            }
            .frame(minHeight: 48)
        }
        .buttonStyle(.borderedProminent)
        .disabled(!viewModel.isButtonEnabled)
    }

    private var formattedDeadline: String {
        viewModel.poll.voteDeadline.formatted(
            date: .abbreviated,
            time: .shortened
        )
    }

    private func optionText(_ option: PollOption) -> String {
        "\(option.name) (\(option.voteCount) votes)"
    }

    private func handleVoteState(
        _ state: PollDetailsViewModel.VoteState
    ) {
        switch state {
        case .idle, .loading:
            break

        case .success:
            alertMessage = AlertMessage(
                title: "Success",
                message: "Your vote was submitted successfully."
            )

        case .failure(let message):
            alertMessage = AlertMessage(
                title: "Error",
                message: message
            )
        }
    }
}

private struct AlertMessage: Identifiable {
    let id = UUID()
    let title: String
    let message: String
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
                )
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
                )
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
                )
            )
        )
    }
}
