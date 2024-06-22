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
    
    func fetchResult<T: Decodable>(url: URL, params: Parameters?, headers: HTTPHeaders, completionHandler: @escaping (T) -> Void) {
        AF.request(url, parameters: params, headers: headers).responseDecodable(of: T.self) { response in
            switch response.result {
            case .success(let value):
                completionHandler(value)
            case .failure(let error):
                print("error")
            }
        }
    }
}

extension NetworkService: NetworkProtocol {
    func fetchCastingData(completionHandler: @escaping (Casting) -> Void) {
        guard let url = URL(string: TMDB.castingUrl) else { return }
        fetchResult(url: url, params: nil, headers: Header.header, completionHandler: completionHandler)
    }
    
    func fetchMovieData(completionHandler: @escaping (MovieContainer) -> Void) {
        guard let url = URL(string: TMDB.movieUrl) else { return }
        fetchResult(url: url, params: nil, headers: Header.header, completionHandler: completionHandler)
    }
    
    func fetchGenreData(completionHandler: @escaping (Genres) -> Void) {
        guard let url = URL(string: TMDB.castingUrl) else { return }
        fetchResult(url: url, params: nil, headers: Header.header, completionHandler: completionHandler)
    }
    
    func fetchSearchData(query: String, page: Int, completionHandler: @escaping (MovieContainer) -> Void) {
        guard let url = URL(string: TMDB.searchUrl) else { return }
        let parameters: Parameters = ["query": query, "include_adult": false, "language": "ko-KR", "page": page]
        fetchResult(url: url, params: parameters, headers: Header.header, completionHandler: completionHandler)
    }
    
    
    
    
}
