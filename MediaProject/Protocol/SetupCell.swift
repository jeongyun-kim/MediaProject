//
//  SetupCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import Foundation

@objc
protocol SetupCell {
    func setupHierarchy()
    func setupConstraints()
    @objc optional func configureLayout()
}
