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

struct TMDBService: NetworkServicing {
    func fetch<T: Decodable>(_ type: T.Type,
                             from endpoint: TMDBEndpoint,
                             completion: @escaping (Result<T, NetworkError>) -> Void) {
        guard let url = endpoint.url else {
            completion(.failure(.badURL))
            return
        }
        
        perform(URLRequest(url: url)) { result in
            switch result {
            case .success(let data):
                guard let decodedObject = data.decode(type: type) else {
                    completion(.failure(.couldNotUnwrap))
                    return
                }
                completion(.success(decodedObject))
            case .failure(let error):
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
            }
        }
    }
}
