//
//  DetailsView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import SwiftUI
import CachedAsyncImage

struct DetailsView: View {
    @StateObject var viewModel: DetailsViewModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading) {
                    if let url = movie.posterURL {
                        posterView(url: url)
                    }

                    VStack(alignment: .leading) {

                        title
                            .padding(.vertical, 8)

                        subtitle

                        details
                            .padding(.top, 8)

                        if let url = viewModel.trailerURL {
                            trailerButton(url: url)
                                .padding(.top, 8)
                        }

                        Spacer()
                    }
                    .padding(.horizontal)
                }
            }
            gradientBackground {
                toolbarButtons
            }
        }
        .toolbar(.hidden)
    }
    
    private var movie: Movie { viewModel.movie }

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

    private func posterView(url: URL) -> some View {
        CachedAsyncImage(url: url) { phase in
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } else {
                Image(systemName: "film")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .foregroundColor(.gray)
            }
        }
    }

    private func trailerButton(url: URL) -> some View {
        Button(action: {
            // Play trailer
        }) {
            HStack {
                Image(systemName: "play.fill")
                Text("Watch Trailer")
            }
        }
        .font(.headline)
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity)
        .background(AppDefault.tintColor.opacity(0.6))
        .cornerRadius(AppDefault.cornerRadius)
        .padding(.top, 16)
    }

    private var toolbarButtons: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .imageScale(.large)
                        .bold()
                }
                .padding(.leading)

                Spacer()
                    .allowsHitTesting(false)

                Button {
                    viewModel.share()
                } label: {
                    Image(systemName: "square.and.arrow.up")
                        .imageScale(.large)
                        .bold()
                }
                .padding(.trailing)
            }

            Spacer()
        }
    }
}

#Preview {
    DetailsView(viewModel: DetailsViewModel(movie: .mock))
}
