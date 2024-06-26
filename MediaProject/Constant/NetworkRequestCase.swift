//
//  NetworkRequestCase.swift
//  MediaProject
//
//  Created by 김정윤 on 6/26/24.
//

import UIKit
import Alamofire

enum NetworkRequestCase {
    case movie
    case genre
    case search(query: String, page: Int)
    case casting(movieId: Int)
    case image(imagePath: String)
    case similarMovie(movieId: Int)
    case recommendMovie(movieId: Int)
    
    var baseURL: String {
        switch self {
        case .movie, .genre, .search, .similarMovie, .recommendMovie, .casting:
            return TMDB.baseURL
        case .image:
            return TMDB.imageBaseURL
        }
    }

    var endPoint: URL? {
        switch self {
        case .movie:
            guard let movieURL = URL(string: baseURL + "trending/movie/day") else { return nil }
            return movieURL
        case .genre:
            guard let genreURL = URL(string: baseURL + "genre/movie/list") else { return nil }
            return genreURL
        case .search:
            guard let searchURL = URL(string: baseURL + "search/movie") else { return nil }
            return searchURL
        case .image(let imagePath):
            guard let imageURL = URL(string: baseURL + "\(imagePath)") else { return nil }
            return imageURL
        case .similarMovie(let movieId):
            guard let similarURL = URL(string: baseURL + "movie/\(movieId)/similar") else { return nil }
            return similarURL
        case .recommendMovie(let movieId):
            guard let recommendURL = URL(string: baseURL + "movie/\(movieId)/recommendations") else { return nil }
            return recommendURL
        case .casting(let movieId):
            guard let castingURL = URL(string: baseURL + "movie/\(movieId)/credits") else { return nil }
            return castingURL
        }
    }
    
    var header: HTTPHeaders {
        return Header.header
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        switch self {
        case .movie, .genre, .casting, .image:
            return ["language": "ko-KR"]
        case .search(let query, let page):
            return ["query": query, "include_adult": false, "language": "ko-KR", "page": page]
        case .similarMovie, .recommendMovie:
            return ["language": "ko-KR"]
        }
    }
}
