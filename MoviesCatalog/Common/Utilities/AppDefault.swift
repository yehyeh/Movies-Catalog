//
//  AppDefault.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation
import SwiftUI

enum AppDefault {
    static var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }


    static var appBgColor: Color { .dynamicBackground }
    static var appFgColor: Color { .dynamicText }
    static var cornerRadius: CGFloat = 16
    static var tintColor: Color { .blue }
    static var placeholderColor: Color { .gray }
}
