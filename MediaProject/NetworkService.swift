//
//  NetworkService.swift
//  MediaProject
//
//  Created by 김정윤 on 6/22/24.
//

import UIKit
import Alamofire

class NetworkService {
    private init() {}
    static let shared = NetworkService()
    
    func fetchResult<T: Decodable>(url: URL, params: Parameters?, completionHandler: @escaping (T) -> Void) {
        AF.request(url, parameters: params, headers: Header.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension NetworkService: NetworkProtocol {
    func fetchCastingData(completionHandler: @escaping (Casting) -> Void) {
        guard let url = URL(string: TMDB.castingUrl) else { return }
        fetchResult(url: url, params: nil, completionHandler: completionHandler)
    }
    
    func fetchMovieData(completionHandler: @escaping (MovieContainer) -> Void) {
        guard let url = URL(string: TMDB.movieUrl) else { return }
        fetchResult(url: url, params: nil, completionHandler: completionHandler)
    }
    
    func fetchGenreData(completionHandler: @escaping (Genres) -> Void) {
        guard let url = URL(string: TMDB.genreUrl) else { return }
        fetchResult(url: url, params: nil, completionHandler: completionHandler)
    }
    
    func fetchSearchData(query: String, page: Int, completionHandler: @escaping (MovieContainer) -> Void) {
        guard let url = URL(string: TMDB.searchUrl) else { return }
        let parameters: Parameters = ["query": query, "include_adult": false, "language": "ko-KR", "page": page]
        fetchResult(url: url, params: parameters, completionHandler: completionHandler)
    }
    
    func fetchSimilarMovieData(completionHandler: @escaping (PosterContainer) -> Void) {
        guard let url = URL(string: TMDB.similarMovieURL) else { return }
        let parameters: Parameters = ["language": "ko-KR"]
        fetchResult(url: url, params: parameters, completionHandler: completionHandler)
    }
    
    func fetchRecommendMovieData(completionHandler: @escaping (PosterContainer) -> Void) {
        guard let url = URL(string: TMDB.recommendMovieURL) else { return }
        let parameters: Parameters = ["language": "ko-KR"]
        fetchResult(url: url, params: parameters, completionHandler: completionHandler)
    }
    
    func fetchPosterData(completionHandler: @escaping (MovieImageContainer) -> Void) {
        guard let url = URL(string: TMDB.movieImageURL) else { return }
        fetchResult(url: url, params: nil, completionHandler: completionHandler)
    }
    
}
