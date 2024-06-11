//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/11/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController, SetupView {
    
    let searchBar = UISearchBar()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupUI()
    }
    
    func setupHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(collectionView)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        
        layout.minimumInteritemSpacing = 8
        layout.minimumLineSpacing = 8
        
        let size = (UIScreen.main.bounds.width - 48) / 3
        layout.itemSize = CGSize(width: size, height: size)
        
        return layout
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        collectionView.backgroundColor = .systemRed
        navigationItem.title = "검색"
    }

}
