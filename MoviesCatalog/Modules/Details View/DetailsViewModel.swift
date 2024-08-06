//
//  DetailsViewModel.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//

import SwiftUI
import Combine

@MainActor
final class DetailsViewModel: ObservableObject {
    @Published var trailer: MovieTrailer?
    @Published var isLoading = false
    @Published var isFavorite = false
    @Published var error: Error?
    @Published var shareContent: ShareLinkContent? = nil

    private let service: MoviesService
    private let favorites: FavoritesService

    let movie: Movie

    init(movie: Movie, service: MoviesService, favorites: FavoritesService) {
        self.movie = movie
        self.service = service
        self.favorites = favorites
        isFavorite = self.favorites.isFavorite(movieId: movie.id)
    }

    func fetchInitialData() {
        fetchTrailerURL()
        generateShareContent()
    }

    func playTrailer() {
        if let url = trailer?.youtubeURL {
            UIApplication.shared.open(url)
        }
    }

    func toggleIsFavorite() {
        isFavorite = !isFavorite
        if isFavorite {
            favorites.removeFavorite(movieId: movie.id)
        } else {
            favorites.addFavorite(movieId: movie.id)
        }
    }

    func generateShareContent() {
        let image = if let posterURL = movie.posterURL,
            let poster = ImageCacheManager.shared.image(for: posterURL) {
                poster
            } else {
                Image(systemName: AppDefault.filmSFPath)
            }

        let item = URL(string: movie.shareLink)!
        let subject = "\(movie.title)(\(movie.releaseYear)) ⭐️\(String(format: "%.1f", movie.voteAverage))"
        let message = "\(movie.shareLink) (shared via Movies-Catalog app)"
        shareContent = .init(item: item,
                             subject: subject,
                             message: message,
                             previewDesc: subject,
                             previewImage: image)
    }

    func fetchTrailerURL() {
        isLoading = true

        Task {
            let result = await self.service.details(id: movie.id)
            await MainActor.run {
                switch result {
                    case .success(let trailers):
                        self.trailer = trailers.first { $0.youtubeURL != nil }

                    case .failure(let error):
                        self.error = error
                        return
                }
                isLoading = false
            }
        }
    }
}
