//
//  TMDBServicing.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/8/21.
//

import Foundation

enum TMDBEndpoint: Hashable {
    case movieSearch
    case movieDetail(Int)
    case movieCredits(Int)
    case movieRecommendations(Int)
    case imageAsset
    case popular
    case nowPlaying
    case topRated
    case upcoming
    
    static let baseURL = "https://api.themoviedb.org/3/"
    static let imageURL = "http://image.tmdb.org/t/p/w500"
    
    var path: String {
        switch self {
        case .movieSearch:
            return "search/movie"
        case .movieDetail(let id):
            return "movie/\(id)"
        case .movieCredits(let id):
            return "/movie/\(id)/credits"
        case .movieRecommendations(let id):
            return "movie/\(id)/similar"
        case .popular:
            return "movie/popular"
        case .nowPlaying:
            return "movie/now_playing"
        case .topRated:
            return "movie/top_rated"
        case .upcoming:
            return "movie/upcoming"
        default:
            return ""
        }
    }
    
    var url: URL? {
        switch self {
        case .movieSearch, .movieDetail, .popular, .nowPlaying, .topRated, .upcoming, .movieCredits, .movieRecommendations:
            guard let url = URL(string: Self.baseURL)?.appendingPathComponent(self.path),
                  var components = URLComponents(url: url, resolvingAgainstBaseURL: true) else { return nil }
            
            let apiKeyQuery = URLQueryItem(name: "api_key", value: "d7a52eac01377fcd82bfa02d2b8bdc03")
            components.queryItems = [apiKeyQuery]
            return components.url
        default:
            return nil
        }
    }
    
    static func urlForImagePath(_ string: String) -> URL? {
        URL(string: Self.imageURL + string)
    }
}

protocol TMDBServicing {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: TMDBEndpoint) async throws -> T?
}

struct TMDBService: NetworkServicing, TMDBServicing {
    func fetch<T: Decodable>(_ type: T.Type, from endpoint: TMDBEndpoint) async throws -> T? {
        guard let url = endpoint.url else {
            throw NetworkError.badURL
        }
        
        do {
            let data = try await perform(URLRequest(url: url))
            guard let object = data.decode(type: type) else {
                throw NetworkError.couldNotUnwrap
            }
            return object
        } catch {
            throw error
        }
    }
}
