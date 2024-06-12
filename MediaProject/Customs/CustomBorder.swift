//
//  Border.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import UIKit

class CustomBorder: UIView {
    
    init(color: UIColor) {
        super.init(frame: .zero)
        configureBorderColor(color)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureBorderColor(_ color: UIColor) {
        self.backgroundColor = color
    }
}
