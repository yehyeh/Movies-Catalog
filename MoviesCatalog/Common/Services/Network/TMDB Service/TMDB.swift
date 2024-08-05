//
//  TMDB.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class TMDB: MoviesService {
    private let session = Session()

    func fetchHomeItems() async -> Result<[Movie], Error> {
        await session.autoAuthAsGuest()

        return await session.homeItems()
    }

    func search(query: String) async -> Result<[Movie], Error> {
        await session.autoAuthAsGuest()

        return await session.search(query: query)
    }

    func details(id: String) async ->  Result<[MovieTrailer], Error> {
        await session.autoAuthAsGuest()

        return await session.trailers(movieId: id)
    }
}
