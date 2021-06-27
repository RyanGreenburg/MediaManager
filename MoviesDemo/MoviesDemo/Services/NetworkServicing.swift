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
    case non200Response(HTTPURLResponse)
    
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
        case .non200Response(let response):
            return "Non 200 Response: \(response.statusCode) ---> \(response.url!.absoluteString)"
        }
    }
}

protocol NetworkServicing {
    func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void)
}

extension NetworkServicing {
    func perform(_ request: URLRequest, completion: @escaping (Result<Data, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("Error in \(#function) -\n\(#file):\(#line) -\n\(error.localizedDescription) \n---\n \(error)")
                completion(.failure(.unexpectedError))
            }
            
            guard let data = data else {
                completion(.failure(.unexpectedError))
                return
            }
            DispatchQueue.main.async {
                completion(.success(data))
            }
        }.resume()
    }
}

extension Data {
    func decode<T: Decodable>(type:T.Type, T_ decoder: JSONDecoder = JSONDecoder()) -> T? {
        return try? decoder.decode(T.self, from: self)
    }
}
