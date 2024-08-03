//
//  String_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

extension String {
    var jsonString: Data? {
        Network.data(from: self)
    }
}
