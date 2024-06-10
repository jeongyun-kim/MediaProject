//
//  MainViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import Alamofire
import SnapKit

class MainViewController: UIViewController, SetupView {
    
    // 영화
    var movieList: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    // 장르
    var genreDict: [Int: String] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    
    let border: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        fetchMovieGenres()
        fetchMovieDatas()
        setupTableView()
        setupUI()
    }
    
    func setupHierarchy() {
        view.addSubview(border)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        border.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(border.snp.bottom)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        let leftItem = UIBarButtonItem(image: UIImage(systemName: "list.bullet"), style: .plain, target: self, action: nil)
        let rightItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: nil)
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        tableView.separatorStyle = .none
    }
    
    // 장르 리스트 딕셔너리로 가져오기
    // - [아이디(Int) : 장르명(String)]
    func fetchMovieGenres()  {
        AF.request(TMDB.genreUrl, headers: TMDB.header).responseDecodable(of: Genres.self) { response in
            switch response.result {
            case .success(let value):
                self.genreDict = value.genreDict
            case .failure(let error):
                print(error)
            }
        }
    }

    // 영화 리스트 가져오기
    func fetchMovieDatas() {
        AF.request(TMDB.movieUrl, headers: TMDB.header).responseDecodable(of: MovieContainer.self) { response in
            switch response.result {
            case .success(let value):
                self.movieList = value.results
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        cell.configureCell(movieList[indexPath.row], genreDict)
        return cell
    }
}
