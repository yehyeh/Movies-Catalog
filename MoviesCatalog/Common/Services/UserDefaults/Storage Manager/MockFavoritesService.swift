//
//  MockFavoritesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

class MockFavoritesService: FavoritesService {
    private var favoriteMovies: Set<Int> = []
    private(set) var isFavoriteCalled = false
    private(set) var addFavoriteCalled = false
    private(set) var removeFavoriteCalled = false
    private(set) var loadFavoritesCalled = false
    private(set) var saveFavoritesCalled = false

    func isFavorite(movieId: Int) -> Bool {
        isFavoriteCalled = true
        return favoriteMovies.contains(movieId)
    }

    func addFavorite(movieId: Int) {
        addFavoriteCalled = true
        favoriteMovies.insert(movieId)
    }

    func removeFavorite(movieId: Int) {
        removeFavoriteCalled = true
        favoriteMovies.remove(movieId)
    }

    func loadFavorites() -> Set<Int> {
        loadFavoritesCalled = true
        return favoriteMovies
    }

    func saveFavorites() {
        saveFavoritesCalled = true
    }
}
