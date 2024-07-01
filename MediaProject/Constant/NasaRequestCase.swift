//
//  NasaRequestCase.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import Foundation

enum NasaRequestCase {
    case image
    
    var baseURL: String {
        return Nasa.nasaBaseURL
    }
    
    var endPoint: URL? {
        guard let randomImage = Nasa.NasaPhoto.allCases.randomElement() else { return nil }
        guard let url = URL(string: baseURL + randomImage.rawValue) else { return nil }
        return url
    }
    
    var errorMessage: String {
        return "이미지를 받아오는데 실패했습니다"
    }
}
