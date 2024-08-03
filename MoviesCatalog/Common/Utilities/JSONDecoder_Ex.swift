//
//  JsonFormatter.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension JSONDecoder {
    static var appDefault: JSONDecoder {
        Network.jsonDecoder
    }
}
