//
//  BaseTableViewCell.swift
//  MediaProject
//
//  Created by 김정윤 on 6/25/24.
//

import UIKit
import SnapKit

class BaseTableViewCell: UITableViewCell, SetupCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupConstraints()
        configureLayout()
    }
    
    func setupHierarchy() {

    }
    
    func setupConstraints() {
        
    }
    
    func configureLayout() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
