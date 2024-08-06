//
//  MovieTrailer.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//

import Foundation

struct MovieTrailer: Codable {
    let id: String
    let name: String
    let key: String
    let publishedAt: String
    let site: String
    let type: String
    let official: Bool
}

extension MovieTrailer {
    var youtubeURL: URL? {
        guard type == "Trailer" && site == "YouTube" else {
            return nil
        }
        return URL(string: "https://www.youtube.com/watch?v=\(key)")
    }
}

extension MovieTrailer {
    static var mock: MovieTrailer {
        .init(id: "58ba538dc3a368668f0148b8",
              name: "Jack Reacher: Never Go Back (2016) - IMAX Trailer - Paramount Pictures",
              key: "DTBcGQWmQ1c",
              publishedAt: "2016-09-29T16:00:00.000Z",
              site: "YouTube",
              type: "Trailer",
              official: true)
    }
}
