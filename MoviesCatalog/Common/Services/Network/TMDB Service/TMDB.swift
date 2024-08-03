//
//  TMDB.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class TMDB: MoviesService {
    private let session = Session()

    func fetchHomePageItems() async throws -> [Movie] {
        try await session.autoAuthAsGuest()

        guard let movie = TMDB.dummy else {
            return []
        }

        return [movie]
    }

    func search(query: String) async throws -> [Movie] {
        try await session.autoAuthAsGuest()

        guard let movie = TMDB.dummy else {
            return []
        }

        return [movie]
    }

    func details(id: String) async throws -> Movie {
        TMDB.dummy!
    }
}
