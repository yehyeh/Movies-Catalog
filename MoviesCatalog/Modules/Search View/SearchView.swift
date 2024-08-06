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
            .navigationTitle("Search movies".localizedCapitalized)
            .searchable(text: $viewModel.searchQuery, prompt: "Type to search".localizedCapitalized)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    gridLayoutButton
                }
            }
            .onAppear {
                viewModel.loadInitialData()
            }
    }

    var content: some View {
        switch viewModel.state {
            case .loading:
                AnyView(ProgressView())

            case .empty(let query, let desc):
                AnyView(viewForEmptyState(title: query, subtitle: desc))

            case .search(let movies):
                AnyView(viewFor(movies: movies))

            case .home(let header,_,_,_,_):
                AnyView(viewFor(movies: header))
        }
    }

    private var gridLayoutButton: some View {
        Button {
            viewModel.toggleGridLayout()
        } label: {
            Image(systemName: viewModel.isGridLayout ? AppDefault.toggleGridOffSFPath : AppDefault.toggleGridOnSFPath)
        }
    }
    
    func viewFor(movies: [Movie]) -> some View {
        if viewModel.isGridLayout {
//            AnyView(horizontalList(movies: movies))
            AnyView(gridFor(movies: movies))
        } else {
            AnyView(listFor(movies: movies))
        }
    }

    //
    //TODO: Integrate to display favorites !
    func horizontalList(movies: [Movie]) -> some View {
        ScrollView {
            HorizontalScrollableListView(movies) { movie in
                NavigationLink {
                    ScreenFactory.shared.makeMovieDetailView(movie: movie)
                } label: {
                    CardView(movie: movie)
                }
            }
            .padding()
        }
    }

    func gridFor(movies: [Movie]) -> some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 160))], spacing: 16) {
                ForEach(movies) { movie in
                    NavigationLink {
                        ScreenFactory.shared.makeMovieDetailView(movie: movie)
                    } label: {
                        CardView(movie: movie)
                    }
                }
            }
            .padding()
        }
    }

    func listFor(movies: [Movie]) -> some View {
        List(movies) { movie in
            NavigationLink {
                ScreenFactory.shared.makeMovieDetailView(movie: movie)
            } label: {
                ListCellView(movie: movie)
            }
        }
    }
    
    func viewForEmptyState(title: String, subtitle: String?) -> some View {
        VStack (alignment: .center) {
            Image(systemName: AppDefault.filmSFPath)
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.placeholderApp)
            Text(title.localizedCapitalized)
                .font(.title)
                .foregroundColor(.placeholderApp)
            if let subtitle {
                Text(subtitle.localizedCapitalized)
                    .font(.title2)
                    .foregroundColor(.placeholderApp)
            }
        }
    }
}

#Preview {
    SearchView(viewModel: SearchViewModel(service: MockMoviesService(), favorites: MockFavoritesService(), userDefaults: MockUserDefaults()))
}
