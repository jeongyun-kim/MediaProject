//
//  SetupView.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit

@objc protocol SetupView {
    func setupHierarchy()
    func setupConstraints()
    @objc optional func setupNavigation()
    @objc optional func setupTableView()
    @objc optional func setupUI()
}
