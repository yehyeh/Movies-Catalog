//
//  SearchResult.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 02/08/2024.
//

import Foundation

extension TMDB {
    struct SearchResult: Decodable {
        let search: [Movie]?
        let totalResults: String?
        let error: String?
        let response: String
//
//        enum CodingKeys: String, CodingKey {
//            case search = "Search"
//            case totalResults = "totalResults"
//            case error = "Error"
//            case response = "Response"
//        }

        var isResponseOk: Bool { response.lowercased().isEqual("True".lowercased()) }
    }
}

extension TMDB {
    public static var dummy: Movie? {
        do {
            let jsonData = """
                {
                "poster_path": "/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg",
                "adult": false,
                "overview": "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
                "release_date": "2016-10-19",
                "genre_ids": [
                53,
                28,
                80,
                18,
                9648
                ],
                "id": 343611,
                "original_title": "Jack Reacher: Never Go Back",
                "original_language": "en",
                "title": "Jack Reacher: Never Go Back",
                "backdrop_path": "/4ynQYtSEuU5hyipcGkfD6ncwtwz.jpg",
                "popularity": 26.818468,
                "vote_count": 201,
                "video": false,
                "vote_average": 4.19
                }
                """.jsonString!

            let movie = try Network.jsonDecoder.decode(Movie.self, from: jsonData)
            print("demo:", movie)
            return movie
        } catch {
            print("Error decoding JSON:", error)
            return nil
        }
    }
}
