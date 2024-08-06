//
//  StoreService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey key: UserDefaultsKey)
    func value(forKey key: UserDefaultsKey) -> Any?
    func string(forKey key: UserDefaultsKey) -> String?
    func integer(forKey key: UserDefaultsKey) -> Int
    func bool(forKey key: UserDefaultsKey) -> Bool
    func removeObject(forKey key: UserDefaultsKey)
}

extension UserDefaults: UserDefaultsProtocol {
    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        self.set(value, forKey: key.key)
    }

    func value(forKey key: UserDefaultsKey) -> Any? {
        return self.value(forKey: key.key)
    }

    func string(forKey key: UserDefaultsKey) -> String? {
        return self.string(forKey: key.key)
    }

    func bool(forKey key: UserDefaultsKey) -> Bool {
        return self.bool(forKey: key.key)
    }

    func integer(forKey key: UserDefaultsKey) -> Int {
        return self.integer(forKey: key.key)
    }

    func removeObject(forKey key: UserDefaultsKey) {
        self.removeObject(forKey: key.key)
    }
}

enum UserDefaultsKey: String {
    case editorChoice
    case favorites
    case isGridLayout

    var key: String {
        return self.rawValue
    }
}
