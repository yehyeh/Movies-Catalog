//
//  MoviesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

enum AuthenticationType: Equatable {
    case none
    case guest(expiryDate: Date?, sessionId: String?)
}

enum SessionError: Error {
    case authenticationFailed
    case sessionExpired
    case networkError(String)
    case invalidResponse
    case itemNotFound
}

protocol MoviesService {
    func fetchHomePageItems() async throws -> [Movie]
    func search(query: String) async throws -> [Movie]
    func details(id: String) async throws -> Movie
}
