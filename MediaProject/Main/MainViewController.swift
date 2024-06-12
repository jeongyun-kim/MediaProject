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
    
    let border: UIView = CustomBorder(color: .systemGray5)
    
    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
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
        
        tableView.separatorStyle = .none
    }
    
    func setupNavigation() {
        let leftItem = UIBarButtonItem(image: UIImage(systemName: ButtonImage.mainLeftBarButton.rawValue), style: .plain, target: self, action: nil)
        let rightItem = UIBarButtonItem(image: UIImage(systemName: ButtonImage.mainRightBarButton.rawValue), style: .plain, target: self, action: #selector(searchBtnTapped))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "현재 급상승 중인 영화"
        navigationItem.backButtonTitle = ""
        navigationController?.navigationBar.tintColor = .black
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    @objc func searchBtnTapped(_ sender: UIButton) {
        let vc = SearchViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // 장르 리스트 딕셔너리로 가져오기
    // - [아이디(Int) : 장르명(String)]
    func fetchMovieGenres()  {
        AF.request(TMDB.genreUrl, headers: Header.header).responseDecodable(of: Genres.self) { response in
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
        AF.request(TMDB.movieUrl, headers: Header.header).responseDecodable(of: MovieContainer.self) { response in
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CastingViewController()
        vc.movie = movieList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
