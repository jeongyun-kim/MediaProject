//
//  DetailViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class DetailViewController: UIViewController, SetupView {
    
    lazy var movie: Movie? = nil
    
    lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if let imagePath = movie!.backdrop_path {
            TMDB.imagePath = imagePath
        }
        imageView.kf.setImage(with: TMDB.movieImageUrl)
        return imageView
    }()
    
    lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemRed
        guard let imagePath = movie!.poster_path else { return imageView }
        TMDB.imagePath = imagePath
        imageView.kf.setImage(with: TMDB.movieImageUrl)
        return imageView
    }()
    
    lazy var movieTitleLabel = Custom.configureLabel(text: movie!.title, size: 24, color: .white, weight: .bold)
    
    lazy var overviewLabel = Custom.configureLabel(text: "줄거리", size: 16, color: .lightGray, weight: .bold)
    
    lazy var tableView = UITableView()
    
    lazy var castingList: [Actor] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TMDB.castingUrl = "\(movie!.id)"
        
        setupHierarchy()
        setupConstraints()
        setupUI()
        fetchCasting()
        setupTableView()
    }
    
    func setupHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(posterImageView)
        view.addSubview(tableView)
        //view.addSubview(overviewLabel)
    }
    
    func setupConstraints() {
        mainImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide).offset(24)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            $0.width.equalTo(view.snp.width).multipliedBy(0.25)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
            $0.bottom.equalTo(mainImageView.snp.bottom).inset(8)
        }
        
//        overviewLabel.snp.makeConstraints {
//            $0.leading.equalTo(posterImageView)
//            $0.top.equalTo(mainImageView.snp.bottom).offset(16)
//        }
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CastingTableViewCell.self, forCellReuseIdentifier: CastingTableViewCell.identifier)
        //tableView.rowHeight = 150
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func fetchCasting() {
        AF.request(TMDB.castingUrl, headers: TMDB.header).responseDecodable(of: Casting.self) { response in
            switch response.result {
            case .success(let value):
                self.castingList = value.cast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return castingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CastingTableViewCell.identifier, for: indexPath) as! CastingTableViewCell
        cell.configureCell(castingList[indexPath.row])
        return cell
    }
}
