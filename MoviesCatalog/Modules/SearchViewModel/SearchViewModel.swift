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
    private var service: MoviesService

    init(service: MoviesService) {
        self.service = service
        bindSearchQueryIntoSearchResults()
    }

    enum State {
        case loading
        case empty(query: String = "***", desc: String? = nil)
        case result([Movie])
    }

    @Published var searchQuery: String = ""
    @Published var state: State = .empty()
    private var searchCancellable: AnyCancellable?
    private var subscriptions = Set<AnyCancellable>()

    func loadInitialData() {
        guard case .empty(_,_) = state else { return }

        reload()
    }

    func reload() {
        Task {
            do {
                try await handleReload()
            }
            catch {
                print("reload failed: \(error)")
            }
        }
    }
}

private extension SearchViewModel {
    func handleReload() async throws {
        var result = [Movie]()
        if case .result(let movies) = state, !movies.isEmpty {
            state = .loading
        } else {
            // trigger status bar loading indicator
        }

        let query = trimmedQuery
        let isSearching = query.count >= 3
        if isSearching {
            result = await searchMovies(query: query)
        } else {
            result = await fetchHomeContent()
        }

        if result.isEmpty {
            if isSearching {
                state = .empty(query: query, desc: "Not found :\\")
            } else {
                state = .empty(desc: "Something went wrong :\\")
            }
        } else {
            state = .result(result)
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

    func searchMovies(query: String) async -> [Movie] {
        do {
            return try await service.search(query: query)
        }
        catch {
            return []
        }
    }

    func fetchHomeContent() async -> [Movie] {
        do {
            return try await service.fetchHomePageItems()
        }
        catch {
            return []
        }
    }

    func bindSearchQueryIntoSearchResults() {
        $searchQuery
            .receive(on: DispatchQueue.main)
            .debounce(for: 0.3, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.reload()
            }
            .store(in: &subscriptions)
    }
}
