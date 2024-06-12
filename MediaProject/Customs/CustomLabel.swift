//
//  CustomLabel.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import UIKit

class CustomLabel: UILabel {
    init(text: String = "", size: CGFloat, color: UIColor = .black, weight: UIFont.Weight = .regular) {
        super.init(frame: .zero)
        configureLabel(text: text, size: size, color: color, weight: weight)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureLabel(text: String, size: CGFloat, color: UIColor, weight: UIFont.Weight) {
        self.text = text
        self.font = .systemFont(ofSize: size, weight: weight)
        self.textColor = color
    }
}
