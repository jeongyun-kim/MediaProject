//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/11/24.
//

import UIKit
import Alamofire
import SnapKit

class SearchViewController: UIViewController, SetupView {
    
    let searchBar = UISearchBar()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var page = 1
    var posters: [String] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupUI()
        setupCollectionView()
        fetchMovieData()
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
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "영화 검색"
        searchBar.placeholder = "영화를 검색해보세요"
    }
    
    static func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16) // 큰 틀(섹션) 레이아웃
        
        layout.minimumInteritemSpacing = 8 // 좌우
        layout.minimumLineSpacing = 8 // 상하
        
        let width = (UIScreen.main.bounds.width - 48) / 3 // 각 셀의 너비
        layout.itemSize = CGSize(width: width, height: width*1.5) // 3:2 비율로 셀 구성
        
        return layout
    }
    
    private func fetchMovieData() {
        let parameters: Parameters = ["query": "어벤져스", "include_adult": false, "language": "ko-KR", "page": 1]
        AF.request(TMDB.searchUrl, parameters: parameters, headers: TMDB.header).responseDecodable(of: MovieContainer.self) { response in
            switch response.result {
            case .success(let value):
                self.posters = value.results.map { $0.poster_path }

            case .failure(let error):
                print(error)
            }
        }
        //query=12&include_adult=false&language=ko-KR&page=1
    }

}

extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        cell.configureCell(posters[indexPath.row])
        return cell
    }
}
