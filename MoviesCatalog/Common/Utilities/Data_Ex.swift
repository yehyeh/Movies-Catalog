//
//  File.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension Data {
    var appDefault: String {
        Network.string(from: self)
    }
}
