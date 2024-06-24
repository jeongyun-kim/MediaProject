//
//  SearchCollectionViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/11/24.
//

import UIKit
import Kingfisher

class SearchCollectionViewCell: UICollectionViewCell, SetupView {
    
    let imageView: UIImageView = CustomImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints {
            $0.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(_ data: String) {
        TMDB.imagePath = data
        imageView.kf.setImage(with: TMDB.movieImageUrl)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
