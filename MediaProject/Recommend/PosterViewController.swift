//
//  RecommendViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/24/24.
//

import UIKit
import SnapKit
import Kingfisher

enum PosterCollectionViewTitle: String, CaseIterable {
    case similaer = "비슷한 영화"
    case recommend = "추천 영화"
    case poster = "포스터"
}

class PosterViewController: BaseTableViewController {
    
    var movie: Movie = Movie(backdrop_path: "", id: 0, original_title: "", overview: "", poster_path: "", media_type: "", adult: false, title: "", original_language: "", genre_ids: [], popularity: 0, release_date: "", video: false, vote_average: 0, vote_count: 0)    
    private var posterList: [[String]] = []

    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupHierarchy() {
        view.addSubview(tableView)
        fetchResults()
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
        let rightBarItem = UIBarButtonItem(image: UIImage(systemName: "ellipsis.circle"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = rightBarItem
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func fetchResults() {
        TMDB.movieId = "\(movie.id)"
        let group = DispatchGroup()
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchSimilarMovieData { result in
                self.posterList.append(result.results.map { $0.posterURL })
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchRecommendMovieData { result in
                self.posterList.append(result.results.map { $0.posterURL })
                group.leave()
            }
        }
        
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchPosterData { result in
                self.posterList.append(result.backdrops.map { $0.fileURL })
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
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
        
        cell.titleLabel.text = PosterCollectionViewTitle.allCases[indexPath.row].rawValue
        
        cell.collectionView.tag = indexPath.row
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        cell.collectionView.register(PosterCollectionViewCell.self, forCellWithReuseIdentifier: PosterCollectionViewCell.identifier)
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
