//
//  Repo.swift
//  Coding Challenge
//
//  Created by obada darkznly on 01.04.22.
//

import Foundation

struct Repo: Decodable {
    var name: String!
    var description: String!
    var createdAt: String!
    var stargazersCount: Int!
    
    enum CodingKeys: String, CodingKey {
        case name
        case description
        case createdAt = "created_at"
        case stargazersCount = "stargazers_count"
    }
}
