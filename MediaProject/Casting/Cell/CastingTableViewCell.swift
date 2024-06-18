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
    
    let profileImageView: UIImageView = CustomImageView(frame: .zero)

    let actorNameLabel = CustomLabel(size: 15, weight: .bold)
    
    let characterLabel = CustomLabel(size: 14, color: .lightGray)
    
    let popularityLabel = CustomLabel(size: 13, color: .systemYellow)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }
    
    func setupHierarchy() {
        contentView.addSubview(profileImageView)
        contentView.addSubview(actorNameLabel)
        contentView.addSubview(characterLabel)
        contentView.addSubview(popularityLabel)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
            $0.verticalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            $0.width.equalTo(80)
            $0.height.equalTo(100)
        }
        
        actorNameLabel.snp.makeConstraints {
            $0.leading.equalTo(profileImageView.snp.trailing).offset(8)
            $0.top.equalTo(profileImageView.snp.top).offset(8)
            $0.trailing.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        characterLabel.snp.makeConstraints {
            $0.leading.equalTo(actorNameLabel)
            $0.top.equalTo(actorNameLabel.snp.bottom).offset(4)
        }
        
        popularityLabel.snp.makeConstraints {
            $0.leading.equalTo(characterLabel)
            $0.top.equalTo(characterLabel.snp.bottom).offset(8)
        }
    }
    
    func configureCell(_ data: Actor) {
        TMDB.imagePath = data.profilePath
        profileImageView.kf.setImage(with: TMDB.movieImageUrl)
        actorNameLabel.text = data.name
        characterLabel.text = data.character
        popularityLabel.text = "\(String(format: "%.1f", data.popularity))"
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
