//
//  RecommendTableViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import UIKit
import SnapKit

class PosterTableViewCell: BaseTableViewCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    override func setupHierarchy() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(collectionView)
    }
    
    override func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView.safeAreaLayoutGuide).offset(4)
            make.leading.equalTo(contentView.safeAreaLayoutGuide).offset(16)
        }
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.horizontalEdges.bottom.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    static func layout(type: PosterCollectionViewCellType = .normal) -> UICollectionViewCompositionalLayout {
        let width: CGFloat = type == .normal ? 0.3 : 0.45
        let topInset: CGFloat = 0
        let bottomInset: CGFloat = 8
        let horizontalInset: CGFloat = 12
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(width), heightDimension: .fractionalHeight(1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: topInset, leading: horizontalInset, bottom: bottomInset, trailing: horizontalInset)
        section.orthogonalScrollingBehavior = .continuous
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
