//
//  CollectionView + Extension.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import UIKit

extension UICollectionView {
    // 검색결과 없을 때 나오는 뷰
    func setupEmptyView() {
        let emptyResultLabel: UILabel = {
            let label = CustomLabel(text: "검색결과가 없습니다 :( ", size: 16, color: .lightGray, weight: .bold)
            label.textAlignment = .center
            return label
        }()
        backgroundView = emptyResultLabel
    }
    
    func restore() {
        backgroundView = nil
    }
}
