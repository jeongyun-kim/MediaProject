//
//  CustomImageView.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import UIKit

class CustomImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView() {
        contentMode = .scaleAspectFill
        layer.cornerRadius = CornerRadius.imageViewCornerRadius
        layer.masksToBounds = true
        backgroundColor = .systemGray5
    }
    
}
