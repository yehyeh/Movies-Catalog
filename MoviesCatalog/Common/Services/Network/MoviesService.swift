//
//  MoviesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

enum AuthenticationType {
    case none
    case failed(error: SessionError)
    case guest(expiryDate: Date?, sessionId: String?)
}

enum SessionError: Error, LocalizedError {
    case authenticationFailed
    case sessionExpired
    case networkError(String)
    case invalidResponse
    case itemNotFound
    case tmdbError(TMDB.ErrorResponse)
    case general(Error)

    var errorDescription: String? {
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
}
protocol MoviesService {
    func fetchHomeItems() async -> Result<[Movie], SessionError>
    func search(query: String) async -> Result<[Movie], SessionError>
    func details(id: String) async -> Result<[MovieTrailer], SessionError>
}
