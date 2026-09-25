//
//  CreateEventImageView.swift
//  EsmorgaiOS
//
//  Created by GitHub Copilot on 21/9/26.
//

import SwiftUI

struct CreateEventImageView: View {

    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: CreateEventViewModel

    init(viewModel: CreateEventViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text(LocalizationKeys.CreateEvent.title.localize())
                            .style(.heading1)
                            .padding(.top, 20)

                        CustomTextField(text: $viewModel.eventImageUrl,
                                        caption: $viewModel.eventImageUrlError,
                                        title: LocalizationKeys.CreateEvent.fieldTitleImage.localize(),
                                        hint: LocalizationKeys.CreateEvent.placeholderImage.localize())
                        .keyboardType(.URL)

                        if let previewUrl = viewModel.previewImageUrl {
                            AsyncImage(url: previewUrl) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .aspectRatio(16.0 / 9.0, contentMode: .fill)
                                case .failure:
                                    placeholder
                                case .empty:
                                    ProgressView()
                                        .frame(maxWidth: .infinity)
                                @unknown default:
                                    placeholder
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 8))

                            CustomButton(title: .constant(LocalizationKeys.CreateEvent.deleteButton.localize()),
                                         buttonStyle: .secondary) {
                                viewModel.clearImage()
                            }
                        } else {
                            CustomButton(title: .constant(LocalizationKeys.CreateEvent.previewButton.localize()),
                                         buttonStyle: .secondary) {
                                viewModel.previewImage()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                CustomButton(title: .constant(LocalizationKeys.CreateEvent.createButton.localize()),
                             buttonStyle: .primary,
                             isLoading: $viewModel.isSubmitting) {
                    Task { await viewModel.submit() }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 24)
            }
        }
        .navigationBar {
            dismiss()
        }
    }

    private var placeholder: some View {
        ZStack {
            Color.onDesactivated
            Image(systemName: "photo")
                .foregroundColor(.onSurfaceVariant)
        }
    }
}
