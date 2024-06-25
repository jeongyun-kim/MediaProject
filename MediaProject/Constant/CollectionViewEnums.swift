//
//  CollectionViewEnums.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import Foundation

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

enum PosterCollectionViewTitle: String, CaseIterable {
    case similaer = "비슷한 영화"
    case recommend = "추천 영화"
    case poster = "포스터"
}

enum PosterCollectionViewCellType {
    case normal
    case poster
}
