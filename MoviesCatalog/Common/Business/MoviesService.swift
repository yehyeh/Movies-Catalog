//
//  MoviesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

enum SessionError: Error, LocalizedError {
    case authenticationFailed
    case sessionExpired
    case networkError(String)
    case invalidResponse
    case itemNotFound
    case tmdbError(TMDB.ErrorResponse)
    case general(Error)

    var errorDescription: String {
        switch self {
            case .authenticationFailed:
                return "Authentication failed. Please try again."
            case .sessionExpired:
                return "Session expired. Please log in again."
            case .networkError(let message):
                return "Network error occurred: \(message)"
            case .invalidResponse:
                return "Invalid response from the server."
            case .itemNotFound:
                return "Requested item not found."
            case .tmdbError(let tmdbError):
                return tmdbError.statusMessage
            case .general(let e):
                return e.localizedDescription
        }
    }

    var keyDecription: String {
        switch self {
            case .authenticationFailed:
                return "authenticationFailed"
            case .sessionExpired:
                return "sessionExpired"
            case .networkError(let message):
                return "networkError: \(message)"
            case .invalidResponse:
                return "invalidResponse"
            case .itemNotFound:
                return "itemNotFound"
            case .tmdbError(let error):
                return "tmdbError(\(error.statusCode))"
            case .general(let error):
                return "general(\(error.localizedDescription))"
        }
    }
}

enum ContextTitle: Hashable {
    case upcoming
    case topRated
    case batch(ids: [Int], name: String)

    var title: String {
        switch self {
            case .upcoming:
                return "Upcoming".localizedCapitalized
            case .topRated:
                return "Top Rated".localizedCapitalized
            case .batch(_ ,let name):
                return name.localizedCapitalized
        }
    }
}

protocol MoviesService {
    func fetchMovies(ids: [Int], context: String) async -> Result<[Movie], SessionError> 
    func fetchHomeItems() async -> [ContextTitle: Result<[Movie], SessionError>]
    func search(query: String) async -> Result<[Movie], SessionError>
    func details(id: Int) async -> Result<[MovieTrailer], SessionError>
}
