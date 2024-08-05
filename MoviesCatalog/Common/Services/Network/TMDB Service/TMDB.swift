//
//  TMDB.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class TMDB: MoviesService {
    private static var homeItems: [Movie] = []

    // A dictionary to cache results for each API URL
    private static var search: Repository<ApiUrl, [Movie]> = .init()
    private static var details: Repository<ApiUrl, [MovieTrailer]> = .init()

    func fetchHomeItems() async -> Result<[Movie], SessionError> {
        if !Self.homeItems.isEmpty {
            return .success(Self.homeItems)
        }

        switch await TMDB.makeNetworkRequest(
            endpoint: .topRatedMovies(),
            successType: MoviesResponse.self,
            innerContext: "Home Items") {
            case .success(let success):
                Self.homeItems = success.results
                return .success(Self.homeItems)
            case .failure(let error):
                return .failure(error)
        }
    }

    func search(query: String) async -> Result<[Movie], SessionError> {
        let endpoint: ApiUrl = .search(query: query)
        
        if let results = Self.search.getResult(for: endpoint), !results.isEmpty {
            return .success(results)
        }

        switch await TMDB.makeNetworkRequest(
            endpoint: endpoint,
            successType: MoviesResponse.self,
            innerContext: "Search") {
            case .success(let success):
                Self.search.storeResult(for: endpoint, result: success.results)
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }

    func details(id: String) async ->  Result<[MovieTrailer], SessionError> {
        let endpoint: ApiUrl = .trailers(movieId: id)

        if let results = Self.details.getResult(for: endpoint), !results.isEmpty {
            return .success(results)
        }

        switch await TMDB.makeNetworkRequest(
            endpoint: endpoint,
            successType: TrailersResponse.self,
            innerContext: "Trailers") {
            case .success(let success):
                Self.details.storeResult(for: endpoint, result: success.results)
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }
}
