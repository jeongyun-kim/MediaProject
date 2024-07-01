//
//  Youtube.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import Foundation

struct YoutubeContainer: Decodable {
    let id: Int
    let results: [YoutubeKey]
}

struct YoutubeKey: Decodable {
    let key: String
}
