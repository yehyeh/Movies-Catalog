//
//  DetailsViewModel.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//

import SwiftUI

@MainActor
final class DetailsViewModel: ObservableObject {
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    var trailerURL: URL? { URL(string: "https://api.themoviedb.org") }
    var posterURL: URL? { movie.posterURL }

    func share() {

    }
}
