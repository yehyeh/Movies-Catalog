//
//  Movie.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

struct Movie: Decodable, Identifiable, Equatable, Hashable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let releaseDate: String
    let voteAverage: Float
    let genreIds: [Int]
    let adult: Bool?
    let originalTitle: String?
    let originalLanguage: String?
    let backdropPath: String?
    let popularity: Double?
    let voteCount: Int?
    let video: Bool?

    var releaseYear: String { Date.year(fromReleaseDate: releaseDate) }
    var posterURL: URL? { posterPath != nil ? URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)") : nil }
    var shareLink: String { TMDB.PublicUse.shareMovie(movieId: "\(id)").link }
}

extension Movie {
    static var mock: Movie {
        .init(id: 343611,
              title: "Jack Reacher: Never Go Back",
              overview: "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
              posterPath: "/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg",
              releaseDate: "2016-10-19",
              voteAverage: 4.19,
              genreIds: [
                53,
                28,
                80,
                18,
                9648
              ],
              adult: false,
              originalTitle: "Jack Reacher: Never Go Back",
              originalLanguage: "en",
              backdropPath: "/4ynQYtSEuU5hyipcGkfD6ncwtwz.jpg",
              popularity: 26.818468,
              voteCount: 201,
              video: false)
    }
}
