//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/11/24.
//

import UIKit
import Alamofire
import SnapKit
import Toast

class SearchViewController: UIViewController, SetupView {
    
    let searchBar = UISearchBar()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var page = 1
    var totalPage = 0
    var posters: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupUI()
        setupCollectionView()
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
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.title = "영화 검색"
        searchBar.placeholder = "영화를 검색해보세요"
        searchBar.delegate = self
    }
    
    private func setupCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.prefetchDataSource = self
        
        collectionView.keyboardDismissMode = .onDrag
        
        collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
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
    
    private func fetchMovieData(_ query: String) {
        let parameters: Parameters = ["query": query, "include_adult": false, "language": "ko-KR", "page": page]
        AF.request(TMDB.searchUrl, parameters: parameters, headers: TMDB.header).responseDecodable(of: MoviePosterContainer.self) { response in
            switch response.result {
            case .success(let value):
                // 포스터 이미지 경로만 -> compactMap으로 nil 아닌 데이터만 가져오기
                let posterImagePaths = value.results.map { $0.poster_path }.compactMap { $0 }
                if self.page == 1 { // 🔍 page가 1 상태라면 새로운 검색
                    self.posters = posterImagePaths
                    self.totalPage = value.total_pages
                } else { // page가 1이 아니라면 이미 보던 검색창이니까 이전데이터에 데이터 추가해주기
                    self.posters.append(contentsOf: posterImagePaths)
                }
                // 데이터 불러오고나서 collectionView 다시 리로딩
                self.collectionView.reloadData()
                // 첫검색 시, 스크롤 맨위로
                if self.page == 1 {
                    self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

// MARK: Pagination
extension SearchViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        // 인덱스의 행이 (검색결과 길이 - 3)일 때
        // 현재 페이지수가 총 페이지수 보다 작을 때
        // => 현재 키워드로 페이지 늘려서 재검색
        for idx in indexPaths {
            if idx.row == posters.count - 3 && page < totalPage {
                guard let keyword = searchBar.text else { return }
                page += 1
                fetchMovieData(keyword)
            }
        }
    }
}

// MARK: CollectionViewExtension
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

// MARK: SearchBarExtension
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        // 검색 버튼을 누른다 = 새로운 검색을 한다 = page를 1로 초기화한다
        page = 1
        fetchMovieData(keyword)
    }
}
