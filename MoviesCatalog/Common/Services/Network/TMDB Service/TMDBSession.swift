//
//  TMDBSession.swift
//  MoviesCatalog
//
//  Created by Yehonatan Yehudai on 01/08/2024.
//

import Foundation

extension TMDB {
    enum ApiUrl: Hashable {
        case createGuestAuth
        case search(query: String)
        case topRatedMovies(page: Int = 1)
        case trailers(movieId: String)

        var url: URL {
            switch self {
                case .createGuestAuth:
                    return URL(string: "https://api.themoviedb.org/3/authentication/guest_session/new")!
                case .search(let query):
                    return URL(string: "https://api.themoviedb.org/3/search/movie?query=\(query)")!
                case .topRatedMovies(let page):
                    return URL(string: "https://api.themoviedb.org/3/movie/top_rated?page=\(page)")!
                case .trailers(let movieId):
                    return URL(string: "https://api.themoviedb.org/3/movie/\(movieId)/videos")!
            }
        }
    }

    enum ApiKeys {
        static let apiKey = "928fa92b6bf4ae3e57e8060627f2aed7"
        static let apiReadAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI5MjhmYTkyYjZiZjRhZTNlNTdlODA2MDYyN2YyYWVkNyIsIm5iZiI6MTcyMjUxNjE1Ni4zMTAwMDA3LCJzdWIiOiI2NmFiNzcyOTRmZTQyMTMxMGNkMmNhOGIiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.jkiIGnm1OXQc6ICHudfo7qzVl0fkThyC1jo616B7-zI"
    }

    enum PublicUse {
        case shareMovie(movieId: String)

        var link: String {
            switch self {
                case .shareMovie(let movieId):
                    return "https://www.themoviedb.org/movie/\(movieId)"
            }
        }

        var url: URL {
            switch self {
                case .shareMovie(_):
                    return URL(string: link)!
            }
        }
    }

    static func makeNetworkRequest<T: Decodable>(
        endpoint: ApiUrl,
        successType: T.Type,
        innerContext: String
    ) async -> Result<T, SessionError> {
        do {
            let request = createGetRequest(url: endpoint.url)
            return try await fetchData(request: request, successType: T.self)
        } catch {
            print("yy_Error_\(innerContext): \(error.localizedDescription)")
            return .failure(.general(error))
        }
    }

    static func createGetRequest(url: URL) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 20
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(ApiKeys.apiReadAccessToken)"
        ]
        return request
    }

    static func fetchData<T: Decodable>(request: URLRequest, successType: T.Type) async throws -> Result <T,SessionError> {
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            return .failure(.networkError(URLError(.badServerResponse).localizedDescription))
        }

        switch httpResponse.statusCode {
            case 200:
                let result = try AppDefault.jsonDecoder.decode(T.self, from: data)
                return .success(result)

            default:
                do {
                    let errorResponse = try AppDefault.jsonDecoder.decode(TMDB.ErrorResponse.self, from: data)
                    return .failure(.tmdbError(errorResponse))
                } catch {
                    return .failure(.networkError("\(httpResponse.statusCode):\(httpResponse.description)"))
                }

        }
    }
}

extension TMDB {
        /// Session Auth preperation that turns out to be redundant
    class Session {
        private var authentication: AuthenticationType = .none

        var isSessionValid: Bool {
            if case .guest(_, _) = authentication {
                return true
            }
            return false
        }

            //
            /// Automatic Auth preperation that turns out to be redundant
            /// - Returns: Auth Error for feedback in case of failure, or nil in case of success
        func autoAuthAsGuest() async -> SessionError? {
            if isSessionValid { return nil }
            let innerContext = "Guest Auth session"

            let result = await TMDB.makeNetworkRequest(
                endpoint: TMDB.ApiUrl.createGuestAuth,
                successType: GuestAuth.SuccessResponse.self,
                innerContext: "Guest Auth session")
            switch result {

                case .success(let response):
                    guard let expiryDate = Date.expiryDate(from: response.expiresAt) else {
                        print("yy_\(innerContext)_ParsingFailed: \(response.expiresAt)")
                        let error: SessionError = .invalidResponse
                        authentication = .failed(error: error)
                        return error
                    }
                    authentication = .guest(expiryDate: expiryDate, sessionId: response.guestSessionId)

                case .failure(let error):
                    authentication = .failed(error: .general(error))
                    return error
            }
            return nil
        }
    }
}
