//
//  RecommendViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/24/24.
//

import UIKit
import SnapKit

class RecommendViewController: UIViewController {
    
    lazy var movie: Movie = Movie(backdrop_path: "", id: 0, original_title: "", overview: "", poster_path: "", media_type: "", adult: false, title: "", original_language: "", genre_ids: [], popularity: 0, release_date: "", video: false, vote_average: 0, vote_count: 0)
    
    lazy var similarMovieList: [Movie] = [] {
        didSet {
            if similarMovieList.count == 0 {
                similarCollectionView.setupEmptyView(.similar)
            } else {
                similarCollectionView.restore()
            }
        }
    }
    
    lazy var recommendMovieList: [Movie] = [] {
        didSet {
            if recommendMovieList.count == 0 {
                recommendCollectionView.setupEmptyView(.recommend)
            } else {
                recommendCollectionView.restore()
            }
        }
    }
    
    lazy var poster: [Movie] = []
    lazy var similarCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    lazy var recommendCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
    lazy var similarMovieLabel = CustomLabel(text: CollectionViewTitle.similar.rawValue, size: 20, weight: .bold)
    lazy var recommendMovieLabel = CustomLabel(text: CollectionViewTitle.recommend.rawValue, size: 20, weight: .bold)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupNavigation()
        setupUI()
        TMDB.similarMovieURL = "\(movie.id)"
        fetchSimilarMovies()
        fetchRecommendMovies()
    }
        
    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 6
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 0, left: spacing, bottom: 0, right: spacing)
        let width = (UIScreen.main.bounds.width - spacing*5) / 3
        layout.itemSize = CGSize(width: width, height: width*1.5)
        return layout
    }
    
    private func fetchSimilarMovies() {
        NetworkService.shared.fetchSimilarMovieData { movie in
            self.similarMovieList = movie.results
            self.similarCollectionView.reloadData()
        }
    }
    
    private func fetchRecommendMovies() {
        NetworkService.shared.fetchRecommendMovieData { movie in
            self.recommendMovieList = movie.results
            self.recommendCollectionView.reloadData()
        }
    }
}

extension RecommendViewController: SetupView {
    func setupHierarchy() {
        view.addSubview(similarMovieLabel)
        view.addSubview(similarCollectionView)
        view.addSubview(recommendMovieLabel)
        view.addSubview(recommendCollectionView)
    }
    
    func setupConstraints() {
        similarMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(6)
        }
        
        similarCollectionView.snp.makeConstraints { make in
            make.top.equalTo(similarMovieLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(0.23)
        }
        
        recommendMovieLabel.snp.makeConstraints { make in
            make.top.equalTo(similarCollectionView.snp.bottom).offset(12)
            make.leading.equalTo(similarMovieLabel.snp.leading)
        }
        
        recommendCollectionView.snp.makeConstraints { make in
            make.top.equalTo(recommendMovieLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(similarCollectionView.snp.height)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        [similarCollectionView, recommendCollectionView].forEach {
            setupCollectionView($0)
        }
    }
    
    func setupNavigation() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = movie.title
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func setupCollectionView(_ collectionView: UICollectionView) {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
    }
    
}

extension RecommendViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView {
        case similarCollectionView:
            return similarMovieList.count
        case recommendCollectionView:
            return recommendMovieList.count
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.identifier, for: indexPath) as! MovieCollectionViewCell
        let data = collectionView == similarCollectionView ? similarMovieList[indexPath.row] : recommendMovieList[indexPath.row]
        cell.configureCell(data: data)
        
        return cell
    }
}
