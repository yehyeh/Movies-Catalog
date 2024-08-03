//
//  TMDBSession.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation
import Combine

extension TMDB {
    class Session {
        typealias GuestAuthSuccessResponse = TMDB.Session.GuestAuth.SuccessResponse
        typealias GuestAuthErrorResponse = TMDB.Session.GuestAuth.ErrorResponse

        private var authentication: AuthenticationType = .none

        func autoAuthAsGuest() async throws {
            if isSessionValid { return }
            do {
                let successResponse = try await createGuestSession()
                guard let expiryDate = Date.appDefault(from: successResponse.expiresAt) else {
                    authentication = .guest(expiryDate: Date().addingTimeInterval(60 * 60), sessionId: successResponse.guestSessionId)
                    print("yy_parsing error: \(successResponse)")
                    return
                }
                authentication = .guest(expiryDate: expiryDate, sessionId: successResponse.guestSessionId)

            } catch let error as GuestAuthErrorResponse {
                authentication = .none
                print("Error: \(error.statusMessage)")

            } catch {
                authentication = .none
                print("Unexpected error: \(error)")
            }
        }
    }
}

fileprivate extension TMDB.Session {
    var isSessionValid: Bool {
        switch authentication {
            case .guest:
                return true

            case .none:
                return false
        }
    }

    func createGuestSession() async throws -> GuestAuthSuccessResponse {
        var request = URLRequest(url: ApiUrl.createGuestAuth)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(ApiKeys.apiReadAccessToken)"
        ]

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))

            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            switch httpResponse.statusCode {
                case 200:
                    let successResponse = try Network.jsonDecoder.decode(GuestAuthSuccessResponse.self, from: data)
                    return successResponse

                default:
                    let errorResponse = try Network.jsonDecoder.decode(GuestAuthErrorResponse.self, from: data)
                    throw errorResponse
            }
        } catch {
            throw error
        }
    }
}

fileprivate extension TMDB.Session {
    enum ApiUrl {
        static var baseURL = "https://api.themoviedb.org/3"
        static func search(query: String) -> URL {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return URL(string: "https://api.themoviedb.org/3/search/movie?query=\(encodedQuery)&api_key=\(ApiKeys.apiKey)")!
        }
        
        static var createGuestAuth: URL {
            URL(string:"\(baseURL)/authentication/guest_session/new")!
        }
    }

    enum ApiKeys {
        static let apiKey = "928fa92b6bf4ae3e57e8060627f2aed7"
        static let apiReadAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjhmYTkyYjZiZjRhZTNlNTdlODA2MDYyN2YyYWVkNyIsIm5iZiI6MTcyMjUxNjE1Ni4zMTAwMDA3LCJzdWIiOiI2NmFiNzcyOTRmZTQyMTMxMGNkMmNhOGIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.jkiIGnm1OXQc6ICHudfo7qzVl0fkThyC1jo616B7-zI"
    }
}
