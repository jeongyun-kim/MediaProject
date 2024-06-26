//
//  Movie.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import Foundation
import Alamofire

// MARK: 영화
struct MovieContainer: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
}

struct Movie: Decodable {
    let backdrop_path: String?
    let id: Int
    let original_title: String
    let overview: String
    let poster_path: String?
    let media_type: String?
    let adult: Bool
    let title: String
    let original_language: String
    let genre_ids: [Int]?
    let popularity: Double
    let release_date: String
    let video: Bool
    let vote_average: Double
    let vote_count: Int
    
    var posterURL: URL? {
        guard let imagePath = poster_path else { return nil }
        guard let url = URL(string: "\(TMDB.imageBaseURL)\(imagePath)") else { return nil }
        return url
    }
    var mainImageURL: URL? {
        guard let imagePath = backdrop_path else { return nil }
        guard let url = URL(string: "\(TMDB.imageBaseURL)\(imagePath)") else { return nil }
        return url
    }
}

struct Overview {
    let overview: String
    var isOpen: Bool = false
}

// MARK: 장르
struct Genres: Decodable {
    let genres: [Genre]
    
    var genreDict: [Int: String]  {
        var dict: [Int: String] = [:]
        for genre in genres {
            dict[genre.id] = genre.name
        }
        return dict
    }
}

struct Genre: Decodable {
    let id: Int
    let name: String
}
