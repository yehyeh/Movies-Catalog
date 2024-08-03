//
//  SessionResponse.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 03/08/2024.
//

import Foundation

extension TMDB.Session {
    enum GuestAuth {
        struct SuccessResponse: Decodable {
            let success: Bool
            let guestSessionId: String
            let expiresAt: String
        }
    }

    struct ErrorResponse: Decodable, Error {
        let statusCode: Int
        let statusMessage: String
        let success: Bool
    }
}
