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
   
    let releaseDate: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .lightGray
        label.text = "2020/12/23"
        return label
    }()
    
    let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.text = "#Mystery"
        return label
    }()
    
    let movieView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.shadowOpacity = 1
        view.backgroundColor = .white
        view.layer.shadowOffset = .zero
        view.layer.shadowColor = UIColor.lightGray.cgColor
        view.layer.shadowRadius = 10
        return view
    }()
    
    let movieImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Alice in Borderland"
        label.font = UIFont.systemFont(ofSize: 18)
        //label.backgroundColor = .white
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "fmadfmadmfamdfkamfk"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    let moreLabel: UILabel = {
        let label = UILabel()
        label.text = "자세히 보기"
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
    let moreImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "ellipsis")
        imageView.tintColor = .black
        return imageView
    }()
    
    let gradeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    let gradeStrLabel: UILabel = {
        let label = UILabel()
        label.text = "평점"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        label.backgroundColor = .systemTeal
        return label
    }()
    
    let gradeLabel: UILabel = {
        let label = UILabel()
        label.text = "8.8"
        label.backgroundColor = .white
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 13)
        return label
    }()
    
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
            $0.height.equalTo(15)
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
    }
    
    func configureCell(_ data: Movie, _ genreDict: [Int: String]) {
        releaseDate.text = data.release_date
        
        gradeLabel.text = String(format: "%.1f", data.vote_average)
        
        let url = URL(string: "\(TMDB.movieImageUrl)\(data.poster_path)")
        movieImageView.kf.setImage(with: url)
        
        titleLabel.text = data.title
        
        descLabel.text = data.overview
        
        var text = ""
        data.genre_ids.forEach {
            text += "#\(genreDict[$0]!) "
        }
        genreLabel.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
