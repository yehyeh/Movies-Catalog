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
        let totalPages: Int
        let totalResults: Int
        let results: [Movie]
    }
}

extension TMDB {
    private static var json1 = """
    {
        "backdrop_path": "/2RVcJbWFmICRDsVxRI8F5xRmRsK.jpg",
        "id": 762441,
        "title": "A Quiet Place: Day One",
        "original_title": "A Quiet Place: Day One",
        "overview": "As New York City is invaded by alien creatures who hunt by sound, a woman named Sam fights to survive with her cat.",
        "poster_path": "/yrpPYKijwdMHyTGIOd1iK1h0Xno.jpg",
        "media_type": "movie",
        "adult": false,
        "original_language": "en",
        "genre_ids": [
        27,
        878,
        53
        ],
        "popularity": 3723.597,
        "release_date": "2024-06-26",
        "video": false,
        "vote_average": 7.021,
        "vote_count": 872
    }
    """
    private static var json2 = """
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
    """
    static var dummy: Movie {
        try! AppDefault.jsonDecoder.decode(Movie.self, from: json1.toData!)
    }
    static var dummy2: Movie {
        try! AppDefault.jsonDecoder.decode(Movie.self, from: json2.toData!)
    }
}
