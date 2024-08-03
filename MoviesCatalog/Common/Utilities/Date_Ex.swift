//
//  Date_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension Date {
    static func formatted(from dateString: String) -> Date? {
        DateFormatter.appDefault.date(from: dateString)
    }
}

extension DateFormatter {
    static var appDefault: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZZ"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        return dateFormatter
    }
}
