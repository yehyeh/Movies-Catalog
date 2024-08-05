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
    @Published var error: Error?
    @Published var shareContent: SharedMovie? = nil

    let movie: Movie
    private let service: MoviesService

    init(movie: Movie, service: MoviesService) {
        self.movie = movie
        self.service = service
    }

    func fetchTrailerURL() {
        isLoading = true

        Task {
            let result = await self.service.details(id: "\(movie.id)")
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
