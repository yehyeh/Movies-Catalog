//
//  MockMoviesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class MockMoviesService: MoviesService {
    func fetchHomeItems() async -> Result<[Movie], any Error> {
        .success([TMDB.dummy,TMDB.dummy2])
    }
    
    func search(query: String) async -> Result<[Movie], any Error> {
        .success([TMDB.dummy])
    }
    
    func details(id: String) async -> Result<Movie, any Error> {
        .success(TMDB.dummy)
    }
}
