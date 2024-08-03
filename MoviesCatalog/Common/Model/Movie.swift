//
//  Movie.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

struct Movie: Decodable, Identifiable, Equatable {
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

    var posterURL: URL? { posterPath != nil ? URL(string: "https://image.tmdb.org/t/p/w500\(posterPath!)") : nil }
}
