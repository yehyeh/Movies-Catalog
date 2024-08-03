//
//  Date_Ex.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension Date {
    static func appDefault(from dateString: String) -> Date? {
        DateFormatter.appDefault.date(from: dateString)
    }
}

extension DateFormatter {
    static var appDefault: DateFormatter {
        Network.dateFormatter
    }
}
