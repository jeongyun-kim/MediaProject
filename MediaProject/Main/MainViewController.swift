//
//  MainViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import SnapKit

class MainViewController: BaseViewControllerNoLargeTitle {
    
    // 영화
    private var movieList: [Movie] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    // 장르
    private var genreDict: [Int: String] = [:] {
        didSet {
            tableView.reloadData()
        }
    }
    private let border: UIView = CustomBorder(color: .systemGray5)
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDatas()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupHierarchy() {
        view.addSubview(border)
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
        border.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        tableView.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            $0.top.equalTo(border.snp.bottom)
        }
    }
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(MovieTableViewCell.self, forCellReuseIdentifier: MovieTableViewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
        
        tableView.separatorStyle = .none
    }
    
    override func setupNavigation() {
        let leftItem = UIBarButtonItem(image: UIImage(systemName: ButtonImageCase.mainLeftBarButton.rawValue), style: .plain, target: self, action: nil)
        let rightItem = UIBarButtonItem(image: UIImage(systemName: ButtonImageCase.mainRightBarButton.rawValue), style: .plain, target: self, action: #selector(searchBtnTapped))
        navigationItem.leftBarButtonItem = leftItem
        navigationItem.rightBarButtonItem = rightItem
        navigationItem.title = "현재 급상승 중인 영화"
        navigationItem.backButtonTitle = ""
    }
    
    @objc func searchBtnTapped(_ sender: UIButton) {
        transition(SearchViewController(), transionStyle: .push)
    }
    
    private func fetchDatas() {
        let group = DispatchGroup()
        
        group.enter()
        // 영화 리스트 가져오기
        DispatchQueue.global().async(group:group) {
            NetworkService.shared.fetchMovieData { data, error in
                if let error = error {
                    self.showToast(message: error)
                } else {
                    guard let data = data else { return }
                    self.movieList = data.results
                }
                group.leave()
            }
        }
        
        group.enter()
        // - [아이디(Int) : 장르명(String)]
        // 장르 리스트 딕셔너리로 가져오기
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchGenreData { data, error in
                if let data = data {
                    self.genreDict = data.genreDict
                }
                group.leave()
            }
        }
                
        group.notify(queue: .main) {
            self.tableView.reloadData()
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
        transition(CastingViewController(movie: movieList[indexPath.row]), transionStyle: .push)
    }
}
