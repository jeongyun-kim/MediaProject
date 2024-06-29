//
//  RecommendViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/24/24.
//

import UIKit
import SnapKit
import Kingfisher

class PosterViewController: BaseTableViewController {
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movie: Movie = Movie(backdrop_path: "", id: 0, original_title: "", overview: "", poster_path: "", media_type: "", adult: false, title: "", original_language: "", genre_ids: [], popularity: 0, release_date: "", video: false, vote_average: 0, vote_count: 0)    
    private var posterList: [[String]] = [[], [], []]

    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchResults()
    }
    
    override func setupHierarchy() {
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PosterTableViewCell.self, forCellReuseIdentifier: PosterTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    override func setupNavigation() {
        navigationItem.title = movie.title
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: ButtonImageCase.moreCircle.rawValue), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func fetchResults() {
        let group = DispatchGroup()
        let id = movie.id
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchSimilarMovieData(movieId: id) { data, error in
                guard let data = data else { return }
                self.posterList[0] = data.results.compactMap { $0.posterURL }
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchRecommendMovieData(movieId: id) { data, error in
                guard let data = data else { return }
                self.posterList[1] = data.results.compactMap { $0.posterURL }
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchPosterData(movieId: id) { data, error in
                if let data = data {
                    self.posterList[2] = data.backdrops.compactMap { $0.fileURL }
                } else {
                    guard let error = error else { return }
                    print(error)
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            //print(self.posterList)
            self.tableView.reloadData()
        }
    }
}

extension PosterViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posterList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PosterTableViewCell.identifier, for: indexPath) as! PosterTableViewCell
        // collectionView Layout 포스터 부분이랑 영화 부분 다르게
        let type: PosterCollectionViewCellType = indexPath.item == 2 ? .poster : .normal
        cell.collectionView.collectionViewLayout = PosterTableViewCell.layout(type: type)
        
        // 만약 네트워크 결과 통신 이후, 아무것도 없는 항목이 있다면 해당 항목에 emptyView 세팅
        if posterList[indexPath.row].isEmpty {
            cell.collectionView.setupEmptyView(CollectionViewEmptyViewText.allCases[indexPath.row].self)
        } else { // 하나라도 있으면 emptyView 제거
            cell.collectionView.restore()
        }
        
        cell.titleLabel.text = PosterCollectionViewTitle.allCases[indexPath.row].rawValue
        
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        cell.collectionView.reloadData()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 마지막 포스터 부분은 좀 더 크게 300
        return indexPath.row == 2 ? 300 : 200
    }
}

extension PosterViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posterList[collectionView.tag].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PosterCollectionViewCell.identifier, for: indexPath) as! PosterCollectionViewCell
        
        let url = URL(string: posterList[collectionView.tag][indexPath.item])
        cell.posterImageView.kf.setImage(with: url)
        return cell
    }
}
