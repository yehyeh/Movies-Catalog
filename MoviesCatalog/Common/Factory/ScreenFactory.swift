//
//  ScreenFactory.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import SwiftUI

protocol ScreenFactoryProtocol {
    func makeHomeView() -> AnyView
    func makeMovieDetailView(movie: Movie) -> AnyView
}

class ScreenFactory: ScreenFactoryProtocol {
    static let shared = ScreenFactory()

    @MainActor
    func makeHomeView() -> AnyView {
        let service = TMDB()
        let favoritesManager = StorageManager.shared
        let userDefaults = UserDefaults.standard
        let viewModel = SearchViewModel(service: service,
                                        favorites: favoritesManager,
                                        userDefaults: userDefaults)
        return AnyView(SearchView(viewModel: viewModel))
    }

    @MainActor
    func makeMovieDetailView(movie: Movie) -> AnyView {
        let service = TMDB()
        let favoritesManager = StorageManager.shared
        let viewModel = DetailsViewModel(movie: movie,
                                         service: service,
                                         favorites: favoritesManager)
        return AnyView(DetailsView(viewModel: viewModel))
    }
    
    private init() {}
}
