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

    static var cornerRadius: CGFloat = 16
    static var starSFPath: String = "star.fill"
    static var filmSFPath: String = "film"
    static var playSFPath: String = "play.fill"
    static var shareSFPath: String = "square.and.arrow.up"
    static var toggleGridOffSFPath: String = "rectangle.grid.1x2"
    static var toggleGridOnSFPath: String = "square.grid.2x2"
}
