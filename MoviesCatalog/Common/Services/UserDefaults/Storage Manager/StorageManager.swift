//
//  StorageManager.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

class StorageManager {
    static let shared = StorageManager()
    private let defaults = UserDefaults.standard
    private let queue = DispatchQueue(label: "com.userDefaults.storagemanager")
    private var favorites = Set<Int>()

    private init() {}

    fileprivate func save<T:Codable>(_ ids: [T], forKey key: UserDefaultsKey) {
        do {
            let data = try JSONEncoder().encode(ids)
            defaults.set(data, forKey: key.rawValue)
        } catch {
            print("yy_FailedEncoding: \(error)")
        }
    }

    fileprivate func load<T:Codable>(key: UserDefaultsKey) -> [T] {
        guard let data = defaults.data(forKey: key.rawValue) else {
            return []
        }
        do {
            return try JSONDecoder().decode([T].self, from: data)
        } catch {
            print("yy_FailedDecoding: \(error)")
            return []
        }
    }
}

extension StorageManager: FavoritesService {
    func isFavorite(movieId: Int) -> Bool {
        favorites.contains(movieId)
    }

    func addFavorite(movieId: Int) {
        queue.async {
            self.favorites.insert(movieId)
        }
        saveFavorites()
    }
    
    func removeFavorite(movieId: Int) {
        queue.async {
            self.favorites.remove(movieId)
        }
        saveFavorites()
    }
    
    func loadFavorites() -> Set<Int> {
        var result: Set<Int>!
        queue.sync {
            result = Set(load(key: .favorites))
        }
        return result
    }
    
    func saveFavorites() {
        queue.async {
            self.save(Array(self.favorites), forKey: .favorites)
        }
    }
}
