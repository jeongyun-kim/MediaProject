//
//  Components.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit

struct Custom {
    static let cornerRadius = CGFloat(10)
    
    static func makeBorder(_ color: UIColor) -> UIView {
        let view = UIView()
        view.backgroundColor = color
        return view
    }
    
    static func configureLabel(text: String = "", size: CGFloat, color: UIColor = .black, weight: UIFont.Weight = .regular) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: size, weight: weight)
        label.textColor = color
        return label
    }
}

