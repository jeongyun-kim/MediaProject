//
//  NetworkProtocol.swift
//  MediaProject
//
//  Created by 김정윤 on 6/22/24.
//

import Foundation

protocol NetworkProtocol {
    func fetchCastingData(completionHandler: @escaping (Casting) -> Void)
    func fetchMovieData(completionHandler: @escaping (MovieContainer) -> Void)
    func fetchGenreData(completionHandler: @escaping (Genres) -> Void)
    func fetchSearchData(query: String, page: Int, completionHandler: @escaping (MovieContainer) -> Void)
}
