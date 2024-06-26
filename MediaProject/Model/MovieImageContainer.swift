//
//  BackgroundImage.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import Foundation

struct MovieImageContainer: Decodable {
    let backdrops: [MovieImage]
}
      
struct MovieImage: Decodable {
    let filePath: String?
    var fileURL: String? {
        guard let imagePath = filePath else { return nil }
        return "\(TMDB.imageBaseURL)\(imagePath)"
    }
    
    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }

}
