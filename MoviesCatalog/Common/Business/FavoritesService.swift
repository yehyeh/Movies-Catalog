//
//  FavoritesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

protocol FavoritesService {
    func isFavorite(movieId: Int) -> Bool
    func addFavorite(movieId: Int)
    func removeFavorite(movieId: Int)
    func loadFavorites() -> Set<Int>
    func saveFavorites()
}
