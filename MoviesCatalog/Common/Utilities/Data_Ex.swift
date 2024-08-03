//
//  Data_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension Data {
    var toString: String {
        String(decoding: self, as: UTF8.self)
    }
}
