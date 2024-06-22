//
//  SearchViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/11/24.
//

import UIKit
import SnapKit
import Toast

class SearchViewController: UIViewController, SetupView {
    
    let searchBar = UISearchBar()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    
    var page = 1
    var totalPage = 0
    var movieList: [Movie] = [] {
        didSet {
            if movieList.count > 0 {
                collectionView.restore()
            } else {
                collectionView.setupEmptyView()
            }
        }
    }
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
    
    func setupNavigation() {
        navigationItem.title = "영화 검색"
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        navigationItem.backButtonTitle = ""
        
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
        let horizontalSpacing: CGFloat = 16
        let spacing: CGFloat = 8
        layout.sectionInset = UIEdgeInsets(top: spacing, left: horizontalSpacing, bottom: spacing, right: horizontalSpacing) // 큰 틀(섹션) 레이아웃
        
        
        layout.minimumInteritemSpacing = spacing // 좌우
        layout.minimumLineSpacing = spacing // 상하
        
        let width = (UIScreen.main.bounds.width - spacing*2 - horizontalSpacing*2) / 3 // 각 셀의 너비
        layout.itemSize = CGSize(width: width, height: width*1.5) // 3:2 비율로 셀 구성
        
        return layout
    }
    
    private func fetchMovieData(_ query: String) {
        NetworkService.shared.fetchSearchData(query: query, page: page) { result in
            // 포스터 이미지 경로만 -> compactMap으로 nil 아닌 데이터만 가져오기
            let posterImagePaths = result.results.map { $0.poster_path }.compactMap { $0 }
            // 검색 결과에서 포스터 이미지가 없는 영화는 가져오지 않으므로 movieList도 poster_path가 nil 이 아닌 데이터만 넣어주기
            let movies = result.results.filter { $0.poster_path != nil }
            if self.page == 1 { // 🔍 page가 1 상태라면 새로운 검색
                self.movieList = movies
                self.posters = posterImagePaths
                self.totalPage = result.total_pages
            } else { // page가 1이 아니라면 이미 보던 검색창이니까 이전데이터에 데이터 추가해주기
                self.posters.append(contentsOf: posterImagePaths)
                self.movieList.append(contentsOf: movies)
            }
            // 데이터 불러오고나서 collectionView 다시 리로딩
            self.collectionView.reloadData()
            // 첫검색 시이고 검색결과가 하나라도 있을 때
            // 스크롤 맨 위로 이동하고 검색결과가 없다는 뷰 지우기
            if self.page == 1 && movies.count > 0 {
                self.collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

//


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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = CastingViewController()
        vc.movie = movieList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}

// MARK: SearchBarExtension
extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text else { return }
        // 검색 버튼을 누른다 = 새로운 검색을 한다 = page를 1로 초기화한다
        page = 1
        fetchMovieData(keyword)
        view.endEditing(true)
    }
}
