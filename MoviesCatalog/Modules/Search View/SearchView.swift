//
//  SearchView.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        content
            .onAppear {
                viewModel.loadInitialData()
            }
            .navigationTitle("Search movies".localizedCapitalized)
            .searchable(text: $viewModel.searchQuery, prompt: "Type to search".localizedCapitalized)
    }

    var content: some View {
        switch viewModel.state {
            case .loading:
                AnyView(ProgressView())

            case .empty(let query, let desc):
                AnyView(viewForEmptyState(title: query, subtitle: desc))

            case .result(let movies):
                AnyView(viewFor(movies: movies))
        }
    }

    func viewForEmptyState(title: String, subtitle: String?) -> some View {
        VStack (alignment: .center) {
            Image(systemName: "film")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            Text(title.localizedCapitalized)
                .font(.title)
                .foregroundColor(.gray)
            if let subtitle {
                Text(subtitle.localizedCapitalized)
                    .font(.title2)
                    .foregroundColor(.gray)
            }
        }
    }

    func listItem(_ movie: Movie) -> some View {
        HStack {
            posterImageView(for: movie.posterURL)

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.releaseYear)
                    .font(.caption)
                HStack {
                    Text("\(movie.voteAverage, specifier: "%.1f")")
                        .font(.caption).bold()
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                }
            }
        }
    }

    @ViewBuilder
    private func posterImageView(for url: URL?) -> some View {
        if let url = url {
            AsyncImage(url: url) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            } placeholder: {
                ProgressView()
                    .frame(width: 100)
            }
        } else {
            Image(systemName: "film")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100)
                .foregroundColor(.gray)
        }
    }

    func viewFor(movies: [Movie]) -> some View {
        VStack {
            HorizontalScrollableListView(items: movies)
            List(movies) { movie in
                NavigationLink {
                    Text(movie.title)
                } label: {
                    listItem(movie)
                }
            }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(service: MockMoviesService()))
}
