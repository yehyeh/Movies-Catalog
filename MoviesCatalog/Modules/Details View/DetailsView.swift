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

                        HStack {
                            title
                            
                            Spacer()

                            VStack {
                                favoriteButton
                            }
                        }
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
                Image(systemName: AppDefault.starSFPath)
                    .foregroundColor(.starApp)

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
            Image(systemName: AppDefault.filmSFPath)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundColor(.placeholderApp)
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
                    Image(systemName: AppDefault.playSFPath)
                }
                Text("Watch Trailer".localizedCapitalized)
                    .padding(.leading)
            }
        }
        .font(.headline)
        .padding()
        .frame(maxWidth: .infinity)
        .foregroundColor(.white)
        .background(Color.tintApp)
        .cornerRadius(AppDefault.cornerRadius)
        .disabled(viewModel.isLoading)
    }

    private var shareButton: some View {
        let button = Image(systemName: AppDefault.shareSFPath)
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

    private var favoriteButton: some View {
        Button {
            viewModel.toggleIsFavorite()
        } label: {
            Image(systemName: viewModel.isFavorite ?
                  AppDefault.favoriteOnSFPath : AppDefault.favoriteOffSFPath)
            .tint(.red)
            .imageScale(.large)
        }
        .shadow(radius: 1)
    }
}

#Preview {
    DetailsView(viewModel: DetailsViewModel(movie: .mock, service: MockMoviesService(), favorites: MockFavoritesService()))
}
