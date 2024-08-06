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
    enum ViewState {
        case loading
        case empty(query: String = "", desc: String? = nil)
        case search([Movie])
        case home(header: [Movie],
                  title1: String? = nil, list1: [Movie]? = nil,
                  title2: String? = nil, list2: [Movie]? = nil)
    }

    private let service: MoviesService
    private let favorites: FavoritesService
    private let userDefaults: UserDefaultsProtocol
    private var subscriptions = Set<AnyCancellable>()
    private var firstTime = true

    @Published var searchQuery: String = ""
    @Published private(set) var state: ViewState = .loading
    @Published private(set) var isGridLayout: Bool = false

    var isSearchable:Bool { trimmedQuery.count >= 3 }

    init(service: MoviesService, favorites: FavoritesService, userDefaults: UserDefaultsProtocol) {
        self.service = service
        self.favorites = favorites
        self.userDefaults = userDefaults
        isGridLayout = userDefaults.bool(forKey: .isGridLayout)
        bindSearchQueryIntoSearchResults()
    }

    func loadInitialData() {
        if firstTime {
            firstTime = false

            loadHomeItems()
        }
    }
    
    func toggleGridLayout() {
        isGridLayout = !isGridLayout
        userDefaults.set(isGridLayout, forKey: .isGridLayout)
    }

    func isFavorite(movieId: Int) -> Bool {
        favorites.isFavorite(movieId: movieId)
    }
}

private extension SearchViewModel {
    func loadHomeItems() {
        state = .loading
        Task {
            let result = await service.fetchHomeItems()
            await MainActor.run {
                self.handle(result: result)
            }
        }
    }

    func handle(result: Result<[Movie], SessionError>) {
        switch result {
            case .success(let results):
                if results.isEmpty {
                    if isSearchable {
                        state = .empty(query: trimmedQuery, desc: "No results".localizedCapitalized)
                    } else {
                        state = .empty(desc: "Something went wrong".localizedCapitalized)
                    }
                } else {
                    if isSearchable {
                        state = .search(results)
                    } else {
                        state = .home(header: results)
                    }
                }

            case .failure(let error):
                //
                // Not for Production (:
                // For deubuging purpose !
                state = .empty(query: error.errorDescription ?? "" , desc: "Something went wrong".localizedCapitalized)
        }
    }

    func searchQueryChanged() {
        guard isSearchable else {
            loadHomeItems()
            return
        }

        state = .loading

        let query = trimmedQuery

        Task {
            let result = await service.search(query: query)
            await MainActor.run {
                self.handle(result: result)
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
            .debounce(for: 0.4, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .sink { [weak self] text in
                self?.searchQueryChanged()
            }
            .store(in: &subscriptions)
    }
}
