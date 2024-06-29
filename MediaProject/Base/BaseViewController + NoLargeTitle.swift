//
//  BaseViewController + NoLargeTitle.swift
//  MediaProject
//
//  Created by 김정윤 on 6/26/24.
//

import UIKit

class BaseViewControllerNoLargeTitle: UIViewController, SetupView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupNavigation()
        setupTableView()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
    
    }
    
    func setupNavigation() {
        
    }
    
    func setupTableView() {
    
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
}