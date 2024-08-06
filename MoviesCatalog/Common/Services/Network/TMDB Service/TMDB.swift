//
//  TMDB.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class TMDB: MoviesService {
    var favoriteIds: [Int] = []
    // A thread-safe Repository to cache results for each API URL
    private static var failedIds: Repository<String, Set<Int>> = .init(maxCapacity: .max)
    private static var cached: Repository<Int, Movie> = .init(maxCapacity: .max)
    private static var homeItems: Repository<ContextTitle, Result<[Movie], SessionError>> = .init(maxCapacity: .max)
    private static var search: Repository<ApiUrl, [Movie]> = .init()
    private static var details: Repository<ApiUrl, [MovieTrailer]> = .init()

    func fetchMovies(ids: [Int], context: String) async -> Result<[Movie], SessionError> {
        await withTaskGroup(of: (Int, Result<Movie, SessionError>).self) { group in
            for id in ids {
                group.addTask {
                    return (id, await self.fetchMovie(id: id, context: context))
                }
            }

            var movies = [Movie]()
            var failed = [String: [Int]]()
            for await (id, result) in group {
                switch result {
                    case .success(let movie):
                        movies.append(movie)

                    case .failure(let error):
                        if var listed = failed[error.keyDecription] {
                            listed.append(id)
                            print("yy_failedFetch_\(id)_\(error.keyDecription)")
                        } else {
                            failed[error.keyDecription] = [id]
                        }
                }
            }

            for (desc, ids) in failed {
                Self.failedIds.storeResult(for: desc, result: Set(ids))
            }
            Self.homeItems.storeResult(for: .batch(ids: ids, name: context), result: .success(movies))

            if movies.isEmpty {
                return .failure(.itemNotFound)
            }
            return .success(movies)
        }
    }

    func fetchHomeItems() async -> [ContextTitle: Result<[Movie], SessionError>] {
        let upcoming = await fetchMovies(endpoint: .upcoming, context: .upcoming)
        let topRated = await fetchMovies(endpoint: .topRatedMovies(), context: .topRated)
        let favs = await fetchMovies(ids: favoriteIds, context: "Favorites")
        return Self.homeItems.dataSource
    }

    private func fetchMovies(endpoint: ApiUrl, context: ContextTitle) async -> Result<[Movie], SessionError> {
        switch await Self.makeNetworkRequest(
            endpoint: endpoint,
            successType: MoviesResponse.self,
            innerContext: context.title) {
            case .success(let success):
                return .success(success.results)
            case .failure(let error):
                return .failure(error)
        }
    }

    func fetchMovie(id: Int, context: String) async ->  Result<Movie, SessionError> {
        if let movie = Self.cached.getResult(for: id) {
            return .success(movie)
        }
        let result  = await Self.makeNetworkRequest(endpoint: .movie(id: id),
                                                    successType: Movie.self,
                                                    innerContext: context)
        if case .success(let movie) = result {
            Self.cached.storeResult(for: movie.id, result: movie)
        }
        return result
    }

    func search(query: String) async -> Result<[Movie], SessionError> {
        let endpoint: ApiUrl = .search(query: query)
        
        if let results = Self.search.getResult(for: endpoint), !results.isEmpty {
            return .success(results)
        }

        switch await Self.makeNetworkRequest(
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

    func details(id: Int) async ->  Result<[MovieTrailer], SessionError> {
        let endpoint: ApiUrl = .trailers(movieId: id)

        if let results = Self.details.getResult(for: endpoint), !results.isEmpty {
            return .success(results)
        }

        switch await Self.makeNetworkRequest(
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
