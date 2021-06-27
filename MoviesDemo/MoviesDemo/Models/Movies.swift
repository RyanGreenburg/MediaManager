//
//  Movies.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/9/21.
//

import Foundation

struct MovieList: Decodable, Hashable {
    let results: [Movie]
}

struct Movie: Decodable, Hashable {
    let title: String
    let overview: String
    let releaseDate: String
    let rating: Double
    let genres: [Genre]?
    let backdropPath: String?
    let posterPath: String?
    let id: Int
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case title
        case overview
        case releaseDate = "release_date"
        case rating = "vote_average"
        case genres
        case backdropPath = "backdrop_path"
        case posterPath = "poster_path"
        case id
    }
}

struct Genre: Decodable, Hashable {
    let name: String
    let id: Int
}
