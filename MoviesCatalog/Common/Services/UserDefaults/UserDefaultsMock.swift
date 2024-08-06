//
//  UserDefaultsMock.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

class MockUserDefaults: UserDefaultsProtocol {
    private var store: [UserDefaultsKey: Any] = [:]

    func set(_ value: Any?, forKey key: UserDefaultsKey) {
        store[key] = value
    }

    func value(forKey key: UserDefaultsKey) -> Any? {
        return store[key]
    }

    func string(forKey key: UserDefaultsKey) -> String? {
        return store[key] as? String
    }

    func integer(forKey key: UserDefaultsKey) -> Int {
        return store[key] as? Int ?? 0
    }

    func bool(forKey key: UserDefaultsKey) -> Bool {
        return store[key] as? Bool ?? false
    }

    func removeObject(forKey key: UserDefaultsKey) {
        store.removeValue(forKey: key)
    }
}
