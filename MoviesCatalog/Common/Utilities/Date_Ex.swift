//
//  Date_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension Date {
    static func expiryDate(from dateString: String) -> Date? {
        DateFormatter.expiryDate.date(from: dateString)
    }

    static func year(fromReleaseDate dateString: String) -> String {
        guard let date = DateFormatter.releaseDateFormatter.date(from: dateString) else { return "" }
        return DateFormatter.yearFormatter.string(from: date)
    }
}

extension DateFormatter {
    static var expiryDate: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }

    static var releaseDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

    static var yearFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
}
