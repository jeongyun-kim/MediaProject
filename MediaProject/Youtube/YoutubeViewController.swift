//
//  YoutubeViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import UIKit
import WebKit

class YoutubeViewController: BaseViewController {
    init(movieTitle: String, youtubeURL: URL) {
        super.init(nibName: nil, bundle: nil)
        self.movieTitle = movieTitle
        self.youtubeURL = youtubeURL
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var movieTitle: String = "" 
    var youtubeURL: URL?
    
    private let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadWebView()
    }
    
    override func setupHierarchy() {
        view.addSubview(webView)
    }
    
    override func setupConstraints() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        
    }
    
    override func setupNavigation(_ title: String) {
        super.setupNavigation(movieTitle)
    }
    
    private func loadWebView() {
        guard let url = youtubeURL else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
