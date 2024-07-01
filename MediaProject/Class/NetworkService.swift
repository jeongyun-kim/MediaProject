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
    
    typealias CompletionHandler<T: Decodable> = (T?, String?) -> Void
    
    func fetchResult<T: Decodable>(request: TMDBRequestCase, completionHandler: @escaping CompletionHandler<T>) {
        guard let url = request.endPoint else { return }
        AF.request(url, parameters: request.params, encoding: URLEncoding.queryString, headers: request.header).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value, nil)
            case .failure(_):
                completionHandler(nil, request.errorMessage)
            }
        }
    }
}

extension NetworkService: NetworkProtocol {
    func fetchCastingData(movieId: Int, completionHandler: @escaping (Casting?, String?) -> Void) {
        fetchResult(request: .casting(movieId: movieId), completionHandler: completionHandler)
    }
    
    func fetchMovieData(completionHandler: @escaping (MovieContainer?, String?) -> Void) {
        fetchResult(request: .movie, completionHandler: completionHandler)
    }
    
    func fetchGenreData(completionHandler: @escaping (Genres?, String?) -> Void) {
        fetchResult(request: .genre, completionHandler: completionHandler)
    }
    
    func fetchSearchData(query: String, page: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void) {
        fetchResult(request: .search(query: query, page: page), completionHandler: completionHandler)
    }
    
    func fetchSimilarMovieData(movieId: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void) {
        fetchResult(request: .similarMoviePoster(movieId: movieId), completionHandler: completionHandler)
    }
    
    func fetchRecommendMovieData(movieId: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void) {
        fetchResult(request: .recommendMoviePoster(movieId: movieId), completionHandler: completionHandler)
    }
    
    func fetchPosterData(movieId: Int, completionHandler: @escaping (MovieImageContainer?, String?) -> Void) {
        fetchResult(request: .moviePoster(movieId: movieId), completionHandler: completionHandler)
    }
    
    func fetchYoutubeURL(movieId: Int, completionHandler: @escaping (YoutubeContainer?, String?) -> Void) {
        fetchResult(request: .youtube(movieId: movieId), completionHandler: completionHandler)
    }
}
