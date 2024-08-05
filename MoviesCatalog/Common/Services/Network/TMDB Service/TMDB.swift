//
//  TMDB.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class TMDB: MoviesService {
    func fetchHomeItems() async -> Result<[Movie], SessionError> {
        switch await TMDB.makeNetworkRequest(
            endpoint: .topRatedMovies(),
            successType: MoviesResponse.self,
            innerContext: "Home Items") {
            case .success(let success):
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }

    func search(query: String) async -> Result<[Movie], SessionError> {
        switch await TMDB.makeNetworkRequest(
            endpoint: .search(query: query),
            successType: MoviesResponse.self,
            innerContext: "Search") {
            case .success(let success):
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }

    func details(id: String) async ->  Result<[MovieTrailer], SessionError> {
        switch await TMDB.makeNetworkRequest(
            endpoint: .trailers(movieId: id),
            successType: TrailersResponse.self,
            innerContext: "Trailers") {
            case .success(let success):
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }
}
