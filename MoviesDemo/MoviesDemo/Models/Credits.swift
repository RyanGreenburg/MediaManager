//
//  Credits.swift
//  MoviesDemo
//
//  Created by RYAN GREENBURG on 6/15/21.
//

import Foundation

struct Credits: Decodable, Hashable {
    let cast: [CastMember]
    let crew: [CrewMember]
}

struct CastMember: Decodable, Hashable {
    let name: String?
    let character: String?
    let photoPath: String?
    let creditID: String?
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case name
        case character
        case photoPath = "profile_path"
        case creditID = "credit_id"
    }
}

struct CrewMember: Decodable, Hashable {
    let name: String?
    let photoPath: String?
    let creditID: String?
    let job: String?
    let uuid = UUID()
    
    enum CodingKeys: String, CodingKey {
        case name
        case photoPath = "profile_path"
        case creditID = "credit_id"
        case job
    }
}
