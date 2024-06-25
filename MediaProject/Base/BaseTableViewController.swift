//
//  BaseViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import UIKit

class BaseTableViewController: UIViewController, SetupView {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraints()
        setupUI()
        setupNavigation()
    }
    
    func setupHierarchy() {
        
    }
    
    func setupConstraints() {
        
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
    }
    
    func setupNavigation() {
        
    }
    
    func setupTableView() {
        
    }
    
}
