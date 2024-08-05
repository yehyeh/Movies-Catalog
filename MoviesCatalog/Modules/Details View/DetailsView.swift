//
//  DetailsView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI
import CachedAsyncImage

struct DetailsView: View {
    @Environment(\.dismiss) var dismiss
    @StateObject private var viewModel: DetailsViewModel
    private let movie: Movie

    init(movie: Movie, viewModel: DetailsViewModel) {
        self.movie = movie
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ScrollView {
            ZStack {
                VStack(alignment: .leading) {
                    posterView.safeAreaPadding(.top, -200)

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

                gradientBackground {
                    toolbarButtons
                }
            }
        }
        .onAppear {
            viewModel.fetchTrailerURL(for: movie)
        }
        .navigationBarHidden(true)
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
            // Play trailer
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Watch Trailer".localizedCapitalized)
            }
        }
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(AppDefault.tintColor.opacity(0.6))
        .cornerRadius(AppDefault.cornerRadius)
    }

    private var toolbarButtons: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .bold()
                }
                .padding(.leading)

                Spacer()
                    .allowsHitTesting(false)

                Button {
//                    viewModel.share
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .bold()
                }
                .padding(.trailing)
            }

            Spacer()
        }
    }
}

#Preview {
    DetailsView(movie: .mock, viewModel: DetailsViewModel(service: MockMoviesService()))
}
