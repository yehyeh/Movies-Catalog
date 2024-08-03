//
//  SearchViewModel.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation
import Combine

@MainActor
final class SearchViewModel: ObservableObject {
    enum State {
        case loading
        case empty(query: String = "***", desc: String? = nil)
        case result([Movie])
    }

    private let service: MoviesService
    private var subscriptions = Set<AnyCancellable>()
    private var firstTime = true

    @Published var searchQuery: String = ""
    @Published var state: State = .loading

    init(service: MoviesService) {
        self.service = service
        bindSearchQueryIntoSearchResults()
    }

    func loadInitialData() {
        if firstTime {
            firstTime = false
            reload()
        }
    }
}

private extension SearchViewModel {
    func reload() {
        if case .result(let movies) = state, movies.isEmpty {
            state = .loading
        } else {
            // trigger status bar loading indicator
        }

        let query = trimmedQuery
        let isSearching = query.count >= 3
        Task {
            var result:Result<[Movie], Error>
            if isSearching {
                result = await service.search(query: query)
            } else {
                result = await service.fetchHomeItems()
            }

            switch result {
                case .success(let results):
                    if results.isEmpty {
                        if isSearching {
                            state = .empty(query: query, desc: "Not found")
                        } else {
                            state = .empty(desc: "Something went wrong")
                        }
                    } else {
                        state = .result(results)
                    }

                case .failure(let e):
                    print("yy_\(isSearching ? "Search" : "Fetch")Error: \(e)")
                    state = .empty(desc: "Something went wrong")
            }
        }
    }

    var trimmedQuery: String {
        let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        let cleanedQuery = trimmedQuery
            .components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")

        return cleanedQuery
    }

    func bindSearchQueryIntoSearchResults() {
        $searchQuery
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.reload()
            }
            .store(in: &subscriptions)
    }
}
