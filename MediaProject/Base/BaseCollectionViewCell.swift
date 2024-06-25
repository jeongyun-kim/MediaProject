//
//  BaseCollectionViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import UIKit
import SnapKit

class BaseCollectionViewCell: UICollectionViewCell, SetupCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    

}
