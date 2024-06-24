//
//  MovieTableViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import Kingfisher
import SnapKit

class MovieTableViewCell: UITableViewCell, SetupView {
    
    let releaseDate = CustomLabel(text: LabelText.releaseDateLabel.rawValue, size: 13, color: .lightGray)

    let genreLabel = CustomLabel(text: LabelText.genreLabel.rawValue, size: 16, weight: .bold)

    let movieView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = CornerRadius.cornerRadius
        view.layer.shadowOpacity = 1
        view.backgroundColor = .white
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = CornerRadius.cornerRadius
        return view
    }()
    
    let movieImageView: UIImageView = {
        let imageView = CustomImageView()
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 좌우상단만 깎기
        return imageView
    }()
    
    let titleLabel = CustomLabel(size: 16)
    
    let descLabel = CustomLabel(size: 16, color: .lightGray)
   
    let border = CustomBorder(color: .darkGray)
    
    let moreLabel = CustomLabel(text: LabelText.moreLabel.rawValue, size: 13)
    
    let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: ButtonImage.more.rawValue)
        imageView.tintColor = .black
        return imageView
    }()
    
    let gradeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let gradeStrLabel = CustomLabel(text: LabelText.gradeLabel.rawValue, size: 13, color: .white)

    let gradeLabel = CustomLabel(size: 13)
 
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        configureLayout()
    }
    
    func setupHierarchy() {
        contentView.addSubview(releaseDate)
        contentView.addSubview(genreLabel)
        contentView.addSubview(movieView)
        movieView.addSubview(movieImageView)
        movieView.addSubview(titleLabel)
        movieView.addSubview(descLabel)
        movieView.addSubview(border)
        movieView.addSubview(moreLabel)
        movieView.addSubview(moreImageView)
        movieView.addSubview(gradeStackView)
        [gradeStrLabel, gradeLabel].forEach { label in
            gradeStackView.addArrangedSubview(label)
        }
    }
    
    func setupConstraints() {
        releaseDate.snp.makeConstraints {
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.leading.equalTo(movieView)
        }
        
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(releaseDate.snp.bottom).offset(4)
            $0.leading.equalTo(movieView)
        }
        
        movieView.snp.makeConstraints {
            $0.centerX.equalTo(contentView.snp.centerX)
            $0.size.equalTo(contentView.snp.width).multipliedBy(0.85)
            $0.top.equalTo(genreLabel.snp.bottom).offset(12)
            $0.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        movieImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(movieView)
            $0.height.equalTo(movieView.snp.height).multipliedBy(0.65)
        }
        
        gradeStackView.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.bottom.equalTo(movieImageView.snp.bottom).inset(16)
            $0.width.equalTo(movieView.snp.width).multipliedBy(0.2)
            $0.height.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(movieImageView.snp.bottom).offset(16)
            $0.horizontalEdges.equalTo(movieView).inset(16)
        }
        
        descLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(2)
            $0.horizontalEdges.equalTo(titleLabel)
        }
        
        border.snp.makeConstraints {
            $0.top.equalTo(descLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(descLabel)
            $0.height.equalTo(1)
        }
        
        moreLabel.snp.makeConstraints {
            $0.leading.equalTo(border)
            $0.top.equalTo(border.snp.bottom).offset(12)
        }
        
        moreImageView.snp.makeConstraints {
            $0.centerY.equalTo(moreLabel.snp.centerY)
            $0.trailing.equalTo(movieView).inset(16)
        }
    }
    
    private func configureLayout() {
        self.selectionStyle = .none
        [gradeStrLabel, gradeLabel].forEach { label in
            label.textAlignment = .center
        }
        gradeStrLabel.backgroundColor = .systemTeal
        gradeLabel.backgroundColor = .white
    }
    
    func configureCell(_ data: Movie, _ genreDict: [Int: String]) {
        releaseDate.text = data.release_date
        
        gradeLabel.text = String(format: "%.1f", data.vote_average)
        
        if let imagePath = data.poster_path {
            TMDB.imagePath = imagePath
        }
        movieImageView.kf.setImage(with: TMDB.movieImageUrl)
        
        titleLabel.text = data.title
        
        descLabel.text = data.overview
        
        var text = ""
        let genres = data.genre_ids?.compactMap { $0 }
        genres?.forEach {
            if let genre = genreDict[$0] {
                text += "#\(genre) "
            }
            
        }
        genreLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
