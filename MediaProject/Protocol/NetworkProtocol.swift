//
//  NetworkProtocol.swift
//  MediaProject
//
//  Created by 김정윤 on 6/22/24.
//

import Foundation

protocol NetworkProtocol {
    func fetchCastingData(movieId: Int, completionHandler: @escaping (Casting?, String?) -> Void)
    func fetchMovieData(completionHandler: @escaping (MovieContainer?, String?) -> Void)
    func fetchGenreData(completionHandler: @escaping (Genres?, String?) -> Void)
    func fetchSearchData(query: String, page: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void)
    func fetchSimilarMovieData(movieId: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void)
    func fetchRecommendMovieData(movieId: Int, completionHandler: @escaping (MovieContainer?, String?) -> Void)
    func fetchPosterData(movieId: Int, completionHandler: @escaping (MovieImageContainer?, String?) -> Void)
    func fetchYoutubeURL(movieId: Int, completionHandler: @escaping (YoutubeContainer?, String?) -> Void)
}
