//
//  OverviewTableViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/18/24.
//

import UIKit
import SnapKit

class OverviewTableViewCell: UITableViewCell, SetupView {
    
    let overviewLabel: UILabel = {
        let label = CustomLabel(size: 14)
        return label
    }()
    
    let expandImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.down")
        imageView.tintColor = .darkGray
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupHierarchy() {
        contentView.addSubview(overviewLabel)
        contentView.addSubview(expandImageView)
    }
    
    func setupConstraints() {
        overviewLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(16)
        }
        
        expandImageView.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(8)
            make.bottom.equalTo(contentView.safeAreaLayoutGuide).inset(8)
            make.size.equalTo(25)
            make.centerX.equalTo(overviewLabel.snp.centerX)
        }
    }
    
    func configureCell(_ data: Overview) {
        let expandImage = data.isOpen ? "chevron.up" : "chevron.down"
        let numberLine = data.isOpen ? 0 : 2
        
        overviewLabel.numberOfLines = numberLine
        expandImageView.image = UIImage(systemName: expandImage)
        overviewLabel.text = data.overview
    }
    
}
