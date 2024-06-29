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
    let backdropPath: String?
    let id: Int
    let originalTitle: String
    let overview: String
    let posterPath: String?
    let mediaType: String?
    let adult: Bool
    let title: String
    let originalLang: String
    let genreIds: [Int]?
    let popularity: Double
    let releaseDate: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey {
        case backdropPath = "backdrop_path"
        case id
        case originalTitle = "original_title"
        case overview
        case posterPath = "poster_path"
        case mediaType = "media_type"
        case adult
        case title
        case originalLang = "original_language"
        case genreIds = "genre_ids"
        case popularity
        case releaseDate = "release_date"
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
    
    var posterURL: String? {
        guard let imagePath = posterPath else { return nil }
        return "\(TMDB.imageBaseURL)\(imagePath)"
    }
    
//    var posterURL: URL? {
//        guard let imagePath = poster_path else { return nil }
//        guard let url = URL(string: "\(TMDB.imageBaseURL)\(imagePath)") else { return nil }
//        return url
//    }
    var mainImageURL: URL? {
        guard let imagePath = backdropPath else { return nil }
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
