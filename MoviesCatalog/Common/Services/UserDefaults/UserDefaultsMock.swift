//
//  UserDefaultsMock.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 06/08/2024.
//

import Foundation

class MockUserDefaults: UserDefaultsProtocol {
    private var store: [UserDefaultsKeys: Any] = [:]

    func set(_ value: Any?, forKey defaultName: UserDefaultsKeys) {
        store[defaultName] = value
    }

    func value(forKey defaultName: UserDefaultsKeys) -> Any? {
        return store[defaultName]
    }

    func string(forKey defaultName: UserDefaultsKeys) -> String? {
        return store[defaultName] as? String
    }

    func integer(forKey defaultName: UserDefaultsKeys) -> Int {
        return store[defaultName] as? Int ?? 0
    }

    func bool(forKey defaultName: UserDefaultsKeys) -> Bool {
        return store[defaultName] as? Bool ?? false
    }

    func removeObject(forKey defaultName: UserDefaultsKeys) {
        store.removeValue(forKey: defaultName)
    }
}
