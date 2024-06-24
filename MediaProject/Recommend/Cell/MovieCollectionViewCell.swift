//
//  MovieCollectionViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/24/24.
//

import UIKit
import SnapKit
import Kingfisher


class MovieCollectionViewCell: UICollectionViewCell {
    let posterImageView = CustomImageView(cornerRadius: CornerRadius.imageViewCornerRadius)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MovieCollectionViewCell: SetupView {
    func setupHierarchy() {
        contentView.addSubview(posterImageView)
    }
    
    func setupConstraints() {
        posterImageView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func configureCell(data: Movie) {
        guard let url = data.posterURL else { return }
        self.posterImageView.setImage(url: url)
    }
}
