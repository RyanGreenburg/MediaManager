//
//  NetworkServicing.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/8/21.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case unexpectedError
    case requestError(Error)
    case badURL
    case couldNotUnwrap
    
    var localizedDescription: String {
        switch self {
        case .requestError(let error):
            return "Error performing the task: \(error.localizedDescription)"
        case .badURL:
            return "Unable to make the request with the given URL"
        case .couldNotUnwrap:
            return "Error parsing requested data"
        case .unexpectedError:
            return ""
        }
    }
}

protocol NetworkServicing {
    func perform(_ request: URLRequest) async throws -> Data
}

extension NetworkServicing {
    func perform(_ request: URLRequest) async throws -> Data {
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let response = response as? HTTPURLResponse {
            print("\(response.statusCode)")
        }
        
        return data
    }
}

extension Data {
    func decode<T: Decodable>(type:T.Type, T_ decoder: JSONDecoder = JSONDecoder()) -> T? {
        return try? decoder.decode(T.self, from: self)
    }
}
