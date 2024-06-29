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
    case moviePoster(movieId: Int)
    case similarMoviePoster(movieId: Int)
    case recommendMoviePoster(movieId: Int)
    
    var baseURL: String {
        return TMDB.baseURL
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
        case .moviePoster(let movieId):
            guard let imageURL = URL(string: baseURL + "movie/\(movieId)/images") else { return nil }
            return imageURL
        case .similarMoviePoster(let movieId):
            guard let similarURL = URL(string: baseURL + "movie/\(movieId)/similar") else { return nil }
            return similarURL
        case .recommendMoviePoster(let movieId):
            guard let recommendURL = URL(string: baseURL + "movie/\(movieId)/recommendations") else { return nil }
            return recommendURL
        case .casting(let movieId):
            guard let castingURL = URL(string: baseURL + "movie/\(movieId)/credits") else { return nil }
            return castingURL
        }
    }
    
    var header: HTTPHeaders {
        return TMDBHeader.header
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var params: Parameters {
        switch self {
        case .movie, .genre, .casting, .similarMoviePoster, .recommendMoviePoster:
            return ["language": "ko-KR"]
        case .search(let query, let page):
            return ["query": query, "include_adult": false, "language": "ko-KR", "page": page]
        case .moviePoster:
            return ["": ""]
        }
    }
    
    var errorMessage: String? {
        switch self {
        case .movie, .casting:
            return "데이터를 불러오는데 실패했습니다"
        case .similarMoviePoster, .recommendMoviePoster:
            return "관련 영화를 불러오는데 실패했습니다"
        case .search:
            return "잠시 후에 다시 시도해주세요"
        default:
            return nil
        }
    }
}
