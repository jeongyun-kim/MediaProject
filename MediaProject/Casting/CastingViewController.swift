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

class CastingViewController: UIViewController, SetupView {
    
    lazy var movie: Movie? = nil
    
    lazy var overview: Overview = Overview(overview: "")
    
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
        imageView.backgroundColor = .systemGray5
        guard let imagePath = movie!.poster_path else { return imageView }
        TMDB.imagePath = imagePath
        imageView.kf.setImage(with: TMDB.movieImageUrl)
        return imageView
    }()
    
    lazy var movieTitleLabel = CustomLabel(text: movie!.title, size: 24, color: .white, weight: .bold)

    lazy var tableView = UITableView()
    
    lazy var castingList: [Actor] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TMDB.castingUrl = "\(movie!.id)"
        setupNavigation()
        setupHierarchy()
        setupConstraints()
        setupUI()
        fetchCasting()
        setupTableView()
        overview = movie.map { Overview(overview: $0.overview )}!
    }
    
    func setupHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(posterImageView)
        view.addSubview(tableView)
    }
    
    func setupConstraints() {
        mainImageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(view.snp.height).multipliedBy(0.25)
        }
        
        movieTitleLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(24)
        }
        
        posterImageView.snp.makeConstraints {
            $0.leading.equalTo(movieTitleLabel)
            $0.top.equalTo(movieTitleLabel.snp.bottom).offset(8)
            $0.width.equalTo(view.snp.width).multipliedBy(0.25)
            $0.height.equalTo(posterImageView.snp.width).multipliedBy(1.5)
            $0.bottom.equalTo(mainImageView.snp.bottom).inset(8)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(12)
            $0.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
        tableView.register(CastingTableViewCell.self, forCellReuseIdentifier: CastingTableViewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    private func fetchCasting() {
        AF.request(TMDB.castingUrl, headers: Header.header).responseDecodable(of: Casting.self) { response in
            switch response.result {
            case .success(let value):
                self.castingList = value.cast
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func setupNavigation() {
        navigationItem.title = movie?.title
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}

extension CastingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return DetailSectionTitles.allCases.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return DetailSectionTitles.allCases[section].rawValue
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return castingList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: OverviewTableViewCell.identifier, for: indexPath) as! OverviewTableViewCell
            cell.configureCell(overview)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: CastingTableViewCell.identifier, for: indexPath) as! CastingTableViewCell
            cell.configureCell(castingList[indexPath.row])
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            overview.isOpen.toggle()
            tableView.reloadData()
        }
    }
}
