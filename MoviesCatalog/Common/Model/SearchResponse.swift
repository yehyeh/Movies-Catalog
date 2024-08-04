//
//  SearchResponse.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 02/08/2024.
//

import Foundation

extension TMDB {
    struct MoviesResponse: Decodable {
        let page: Int?
        let totalPages: Int?
        let totalResults: Int?
        let results: [Movie]
    }
}
