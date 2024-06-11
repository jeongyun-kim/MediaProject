//
//  CastingTableViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class CastingTableViewCell: UITableViewCell, SetupView {
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray
        return imageView
    }()

    let actorNameLabel = Custom.configureLabel(text: "이름", size: 14)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(actorNameLabel)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.width.equalTo(60)
            $0.height.equalTo(80)
            $0.centerY.equalTo(contentView.snp.centerY)
        }
        
        actorNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.top.equalTo(contentView.safeAreaLayoutGuide).offset(8)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
    }
    
    func configureCell(_ data: Actor) {
        if let imagePath = data.profile_path {
            TMDB.imagePath = imagePath
            profileImageView.kf.setImage(with: TMDB.movieImageUrl)
        }
        actorNameLabel.text = data.name
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
