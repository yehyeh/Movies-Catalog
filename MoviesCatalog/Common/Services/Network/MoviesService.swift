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
    func fetchHomeItems() async -> Result<[Movie], Error>
    func search(query: String) async -> Result<[Movie], Error>
    func details(id: String) async -> Result<Movie, Error>
}
