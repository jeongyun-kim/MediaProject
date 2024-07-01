//
//  DetailViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit
import SnapKit
import Kingfisher

class CastingViewController: BaseTableViewControllerNoLargeTitle {
    init(movie: Movie) {
        super.init(nibName: nil, bundle: nil)
        self.movie = movie
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movie: Movie = Movie(backdropPath: "", id: 0, originalTitle: "", overview: "", posterPath: "", mediaType: "", adult: false, title: "", originalLang: "", genreIds: [], popularity: 0, releaseDate: "", video: false, voteAverage: 0, voteCount: 0)
    lazy var overview: Overview = Overview(overview: "")
    private var youtubeURL: URL?
    private var castingList: [Actor] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        if let imagePath = movie.backdropPath {
            guard let url = URL(string: TMDB.imageBaseURL + imagePath) else { return imageView }
            imageView.kf.setImage(with: url)
        }
        return imageView
    }()
    private lazy var posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .systemGray5
        if let imagePath = movie.posterURL {
            guard let url = URL(string: imagePath) else { return imageView }
            imageView.kf.setImage(with: url)
        }
        return imageView
    }()
    private let youtubeButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: ButtonImageCase.youtube.rawValue)
        button.setImage(image, for: .normal)
        button.tintColor = .white
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    private lazy var movieTitleLabel = CustomLabel(text: movie.title, size: 24, color: .white, weight: .bold)
    private let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
        overview = Overview(overview: movie.overview)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setupHierarchy() {
        view.addSubview(mainImageView)
        view.addSubview(movieTitleLabel)
        view.addSubview(posterImageView)
        view.addSubview(youtubeButton)
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
        
        youtubeButton.snp.makeConstraints { make in
            make.size.equalTo(36)
            make.bottom.trailing.equalTo(mainImageView).inset(12)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(mainImageView.snp.bottom).offset(12)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide)
            $0.bottom.equalTo(view)
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
    
    
    override func setupNavigation(title: String) {
        super.setupNavigation(title: movie.title)
        let rightBarItem = UIBarButtonItem(title: "관련 콘텐츠", style: .plain, target: self, action: #selector(rightBarBtnTapped))
        navigationItem.rightBarButtonItem = rightBarItem
    }
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        youtubeButton.addTarget(self, action: #selector(youtubeBtnTapped), for: .touchUpInside)
    }

    private func fetchData() {
        let group = DispatchGroup()
        
        // 캐스팅 정보 받아오기
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchCastingData(movieId: self.movie.id) { data, error in
                if let data = data {
                    self.castingList = data.cast
                } else {
                    guard let errorMessage = error else { return }
                    self.showToast(message: errorMessage)
                }
                group.leave()
            }
        }
        // Youtube 링크 받아오기
        // - 따로 에러 메시지 필요없으므로 에러 처리 X
        group.enter()
        DispatchQueue.global().async(group: group) {
            NetworkService.shared.fetchYoutubeURL(movieId: self.movie.id) { data, error in
                if let data = data, data.results.count > 0 { // 데이터가 있고 링크 정보가 1개라도 있다면
                    guard let url = URL(string: Youtube.youtubeBaseURL + data.results[0].key) else { return }
                    self.youtubeURL = url
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            let result = self.youtubeURL != nil // youtube 링크가 있는지 확인
            self.youtubeButton.isHidden = !result // youtube 링크가 있으면(true) -> isHidden = false
        }
    }
    
    @objc func youtubeBtnTapped(_ sender: UIButton) {
        print(#function)
        guard let youtubeURL = youtubeURL else { return }
        transition(YoutubeViewController(movieTitle: movie.title, youtubeURL: youtubeURL), transionStyle: .push)
    }
    
    @objc func rightBarBtnTapped(_ sender: UIButton) {
        transition(PosterViewController(movie: movie), transionStyle: .push)
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
