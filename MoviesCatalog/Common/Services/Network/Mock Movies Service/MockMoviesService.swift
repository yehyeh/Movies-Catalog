//
//  MockMoviesService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

class MockMoviesService: MoviesService {
    func fetchHomeItems() async -> Result<[Movie], SessionError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([.mock, .mock])
    }
    
    func search(query: String) async -> Result<[Movie], SessionError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success([.mock])
    }
    
    func details(id: String) async -> Result<[MovieTrailer], SessionError> {
        try! await Task.sleep(nanoseconds: 1_000_000_000)
        return .success( [.mock] )
    }
}
