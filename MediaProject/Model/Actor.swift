//
//  Actor.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import Foundation

struct Casting: Decodable {
    let id: Int
    let cast: [Actor]
}

struct Actor: Decodable {
    let name: String
    let popularity: Double
    let profilePath: String
    let character: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case popularity
        case profilePath = "profile_path"
        case character
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        self.popularity = try container.decode(Double.self, forKey: .popularity)
        // 프로필이 없는 경우가 있음! <- decodeIfPresent
        // 프로필 없는 경우 초깃값 넣어주기
        self.profilePath = try container.decodeIfPresent(String.self, forKey: .profilePath) ?? ""
        self.character = try container.decode(String.self, forKey: .character)
    }
}

