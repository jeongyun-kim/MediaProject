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
    let adult: Bool
    let gender: Int
    let id: Int
    let known_for_department: String
    let name: String
    let original_name: String
    let popularity: Double
    let profile_path: String? // 프로필이 없는 경우가 있음!
    let cast_id: Int
    let character: String
    let credit_id: String
    let order: Int
}

