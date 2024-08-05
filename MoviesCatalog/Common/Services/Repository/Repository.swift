//
//  Repository.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 05/08/2024.
//

import Foundation

final class Repository<Key: Hashable, Value> {
    private var dataSource: [Key: Value] = [:]
    private let queue = DispatchQueue(label: "com.repository.\(UUID())")
    let maxCapacity: Int

    init(maxCapacity: Int = 10) {
        self.maxCapacity = maxCapacity
    }

    func storeResult(for key: Key, result: Value) {
        queue.async {
            self.dataSource[key] = result
        }
    }

    func getResult(for key: Key) -> Value? {
        var result: Value?
        queue.sync {
            result = self.dataSource[key]
        }
        return result
    }
}
