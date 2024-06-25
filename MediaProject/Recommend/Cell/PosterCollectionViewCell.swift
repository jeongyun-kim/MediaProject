//
//  PosterCollectionViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import UIKit

class PosterCollectionViewCell: BaseCollectionViewCell {
    let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .lightGray
        return imageView
    }()
    
    override func setupHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    override func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide).inset(4)
        }
    }
}
