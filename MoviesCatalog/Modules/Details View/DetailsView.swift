//
//  DetailsView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI

struct DetailsView: View {
    @StateObject private var viewModel: DetailsViewModel
    private var movie: Movie { viewModel.movie }

    init(viewModel: DetailsViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    posterView

                    VStack(alignment: .leading) {

                        title
                            .padding(.vertical, 8)

                        subtitle

                        details
                            .padding(.top, 8)

                        if let url = viewModel.trailer?.youtubeURL {
                            trailerButton(url: url)
                                .padding(.top, 8)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                shareButton
            }
        }
        .onAppear {
            viewModel.fetchInitialData()
        }
    }

    private var title: some View {
        Text(movie.title)
            .font(.title)
            .bold()
    }

    private var subtitle: some View {
        HStack(alignment: .bottom) {
            Text("Released on: \(movie.releaseYear)")
                .font(.headline)
                .foregroundColor(.secondary)

            Spacer()

            HStack(alignment: .center) {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)

                Text("\(movie.voteAverage, specifier: "%.1f")")
                    .font(.title2)
                    .bold()
            }
        }
    }

    private var details: some View {
        Text(movie.overview)
            .font(.body)
    }

    private var posterView: some View {
        CachedAsyncImage(url: movie.posterURL) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
        } placeholder: {
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.gray)
        }
    }

    private func trailerButton(url: URL) -> some View {
        Button(action: {
            viewModel.playTrailer()
        }) {
            HStack {
                if viewModel.isLoading {
                    ProgressView().imageScale(.small)
                } else {
                    Image(systemName: "play.fill")
                }
                Text("Watch Trailer".localizedCapitalized)
                    .padding(.leading)
            }
        }
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(AppDefault.tintColor)
        .cornerRadius(AppDefault.cornerRadius)
        .disabled(viewModel.isLoading)
    }

    private var shareButton: some View {
        let button = Image(systemName: "square.and.arrow.up")
        guard let share = viewModel.shareContent else {
            return AnyView(Button {
                viewModel.generateShareContent()
            } label: {
                button
            })
        }

        return AnyView(ShareLink(item: share.item,
                                 subject: Text(share.subject),
                                 message: Text(share.message),
                                 preview: SharePreview(share.previewDesc, image: share.previewImage)) {
            button
        })
    }
}

#Preview {
    DetailsView(viewModel: DetailsViewModel(movie: .mock, service: MockMoviesService()))
}
