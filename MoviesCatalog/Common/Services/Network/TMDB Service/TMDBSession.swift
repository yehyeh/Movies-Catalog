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
        private var authentication: AuthenticationType = .none

        func autoAuthAsGuest() async {
            if isSessionValid { return }
            do {
                let successResponse = try await createGuestSession()
                guard let expiryDate = Date.expiryDate(from: successResponse.expiresAt) else {
                    print("yy_ParsingFailed: \(successResponse)")
                    return
                }
                authentication = .guest(expiryDate: expiryDate, sessionId: successResponse.guestSessionId)

            } catch let error as ErrorResponse {
                authentication = .none
                print("yy_Error: \(error.statusMessage)")

            } catch {
                authentication = .none
                print("yy_UnexpectedError: \(error)")
            }
        }

        func search(query: String) async -> Result<[Movie], Error> {
            do {
                let results = try await fetchSearch(query: query).results
                return .success(results)
            } catch let error as ErrorResponse {
                print("yy_SearchError: \(error.statusMessage)")
                return .failure(error)
            } catch {
                print("yy_SearchUnexpectedError: \(error)")
                return .failure(error)
            }
        }

        func homeItems(page: Int = 1) async -> Result<[Movie], Error> {
            do {
                let results = try await fetchHomeItems(page: page).results
                return .success(results)
            } catch let error as ErrorResponse {
                print("yy_HomeError: \(error.statusMessage)")
                return .failure(error)
            } catch {
                print("yy_HomeUnexpectedError: \(error)")
                return .failure(error)
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

    func createGuestSession() async throws -> GuestAuth.SuccessResponse {
        var request = URLRequest(url: ApiUrl.createGuestAuth)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(ApiKeys.apiReadAccessToken)"
        ]

        return try await fetchData(request: request,
                                   successType: GuestAuth.SuccessResponse.self,
                                   errorType: ErrorResponse.self)
    }

    func fetchSearch(query: String) async throws -> TMDB.MoviesResponse {
        var request = URLRequest(url: ApiUrl.search(query: query))
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        return try await fetchData(request: request,
                                   successType: TMDB.MoviesResponse.self,
                                   errorType: ErrorResponse.self)
    }

    func fetchHomeItems(page: Int) async throws -> TMDB.MoviesResponse {
        var request = URLRequest(url: ApiUrl.homeItems(page: page))
        request.httpMethod = "GET"
        request.timeoutInterval = 20

        return try await fetchData(request: request,
                                   successType: TMDB.MoviesResponse.self,
                                   errorType: ErrorResponse.self)
    }

    func fetchData<T: Decodable, U: Decodable&Error>(request: URLRequest, successType: T.Type, errorType: U.Type) async throws -> T {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
            }

            switch httpResponse.statusCode {
                case 200:
                    let successResponse = try AppDefault.jsonDecoder.decode(T.self, from: data)
                    return successResponse

                default:
                    let errorResponse = try AppDefault.jsonDecoder.decode(U.self, from: data)
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

        static func homeItems(page: Int) -> URL {
            URL(string:"\(baseURL)/movie/top_rated?api_key=\(ApiKeys.apiKey)&page=\(page)")!
        }

        static func search(query: String) -> URL {
            let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            return URL(string: "\(baseURL)/search/movie?query=\(encodedQuery)&api_key=\(ApiKeys.apiKey)")!
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
