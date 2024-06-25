//
//  Poster.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import Foundation

struct PosterContainer: Decodable {
    let page: Int
    let results: [Poster]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String, CodingKey {
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct Poster: Decodable {
    let posterPath: String
    var posterURL: String {
        return "\(TMDB.imageDBURL)\(posterPath)"
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
    }
}
