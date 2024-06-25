//
//  Poster.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import Foundation

struct PosterContainer {
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

struct Poster {
    let posterPath: String
    var posterUrl: String {
        return "\(TMDB.imageUrlString)\(posterPath)"
    }
    
    enum CodingKeys: String, CodingKey {
        case posterPath = "poster_path"
    }
}
