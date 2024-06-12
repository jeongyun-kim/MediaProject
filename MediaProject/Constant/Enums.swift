//
//  Enums.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import Foundation

enum CornerRadius {
    static let cornerRadius = CGFloat(10)
    static let imageViewCornerRadius = CGFloat(6)
}

enum ButtonImage: String {
    case mainLeftBarButton = "list.bullet"
    case mainRightBarButton = "magnifyingglass"
    case more = "ellipsis"
}


enum LabelText: String {
    case gradeLabel = "평점"
    case moreLabel = "자세히 보기"
    case genreLabel = "#장르"
    case releaseDateLabel = "개봉일"
    case overviewLabel = "줄거리"
}
