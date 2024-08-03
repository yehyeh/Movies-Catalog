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

    func viewForEmptyState(title: String, subtitle: String?) -> some View {
        VStack (alignment: .center) {
            Image(systemName: "flag.fill")
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
            AsyncImage(url: movie.posterURL) { poster in
                poster
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100)
            } placeholder: {
                ProgressView()
                    .frame(width: 100)
            }

            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text("\(movie.releaseDate), \(movie.originalLanguage)")
                    .font(.caption)
                    .lineLimit(3)
            }
        }
    }

    func viewFor(movies: [Movie]) -> some View {
        List(movies) { movie in
            NavigationLink {
                Text(movie.title)
            } label: {
                listItem(movie)
            }
        }
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

    var body: some View {
        content
            .onAppear {
                viewModel.loadInitialData()
            }
            .navigationTitle("Search movies".localizedCapitalized)
            .searchable(text: $viewModel.searchQuery, prompt: "Type to search".localizedCapitalized)
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(service: MockMoviesService()))
}
