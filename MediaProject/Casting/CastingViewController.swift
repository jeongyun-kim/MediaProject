//
//  DetailViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class CastingViewController: BaseViewControllerNoLargeTitle {
    
    var movie: Movie = Movie(backdrop_path: "", id: 0, original_title: "", overview: "", poster_path: "", media_type: "", adult: false, title: "", original_language: "", genre_ids: [], popularity: 0, release_date: "", video: false, vote_average: 0, vote_count: 0)
    lazy var overview: Overview = Overview(overview: "")
    private var castingList: [Actor] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if let imagePath = movie.backdrop_path {
            guard let url = URL(string: TMDB.imageBaseURL + imagePath) else { return imageView }
            imageView.kf.setImage(with: url)
        }
        return imageView
    }()
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        if let imagePath = movie.poster_path {
            guard let url = URL(string: TMDB.imageBaseURL + imagePath) else { return imageView }
            imageView.kf.setImage(with: url)
        }
        return imageView
    }()
    private lazy var movieTitleLabel = CustomLabel(text: movie.title, size: 24, color: .white, weight: .bold)
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCasting()
        overview = Overview(overview: movie.overview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(posterImageView)
        view.addSubview(tableView)
    }
    
    override func setupConstraints() {
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
    
    override func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(OverviewTableViewCell.self, forCellReuseIdentifier: OverviewTableViewCell.identifier)
        tableView.register(CastingTableViewCell.self, forCellReuseIdentifier: CastingTableViewCell.identifier)
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    
    override func setupNavigation() {
        navigationItem.title = movie.title
    }
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
    }

    private func fetchCasting() {
        NetworkService.shared.fetchCastingData(movieId: movie.id) { data, error in
            if let data = data {
                self.castingList = data.cast
            } else {
                guard let errorMessage = error else { return }
                self.showToast(message: errorMessage)
            }
        }
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
