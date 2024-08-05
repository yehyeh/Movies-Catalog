//
//  MoviesResponse.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 02/08/2024.
//

import Foundation

extension TMDB {
    struct ErrorResponse: Decodable, Error {
        let statusCode: Int
        let statusMessage: String
        let success: Bool
    }

    struct MoviesResponse: Decodable {
        let page: Int?
        let totalPages: Int?
        let totalResults: Int?
        let results: [Movie]
    }

    struct TrailersResponse: Codable {
        let id: Int
        let results: [MovieTrailer]
    }
}
