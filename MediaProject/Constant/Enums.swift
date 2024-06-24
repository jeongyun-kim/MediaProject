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

enum DetailSectionTitles: String, CaseIterable {
    case overview = "줄거리"
    case casting = "캐스팅"
}

enum CollectionViewTitle: String {
    case similar = "비슷한 영화"
    case recommend = "추천 영화"
    case posters = "포스터"
}

enum CollectionViewType: String {
    case search = "검색결과가 없습니다 :( "
    case recommend = "관련 추천 영화가 없습니다 X( "
    case similar = "비슷한 영화가 없어요 T^T"
}
