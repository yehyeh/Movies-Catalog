//
//  StoreService.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

protocol UserDefaultsProtocol {
    func set(_ value: Any?, forKey defaultName: UserDefaultsKeys)
    func value(forKey defaultName: UserDefaultsKeys) -> Any?
    func string(forKey defaultName: UserDefaultsKeys) -> String?
    func integer(forKey defaultName: UserDefaultsKeys) -> Int
    func bool(forKey defaultName: UserDefaultsKeys) -> Bool
    func removeObject(forKey defaultName: UserDefaultsKeys)
}

extension UserDefaults: UserDefaultsProtocol {
    func set(_ value: Any?, forKey key: UserDefaultsKeys) {
        self.set(value, forKey: key.key)
    }

    func value(forKey key: UserDefaultsKeys) -> Any? {
        return self.value(forKey: key.key)
    }

    func string(forKey key: UserDefaultsKeys) -> String? {
        return self.string(forKey: key.key)
    }

    func bool(forKey key: UserDefaultsKeys) -> Bool {
        return self.bool(forKey: key.key)
    }

    func integer(forKey key: UserDefaultsKeys) -> Int {
        return self.integer(forKey: key.key)
    }

    func removeObject(forKey key: UserDefaultsKeys) {
        self.removeObject(forKey: key.key)
    }
}

enum UserDefaultsKeys: String {
    case isGridLayout

    var key: String {
        return self.rawValue
    }
}
