//
//  CustomImageView.swift
//  MediaProject
//
//  Created by 김정윤 on 6/12/24.
//

import UIKit

class CustomImageView: UIImageView {
    
    init(cornerRadius: CGFloat = CornerRadius.imageViewCornerRadius) {
        super.init(frame: .zero)
        configureImageView(cornerRadius)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureImageView(_ cornerRadius: CGFloat) {
        contentMode = .scaleAspectFill
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = true
        backgroundColor = .systemGray5
    }
    
    // Data로 이미지 넣어보기 
    func setImage(url: URL) {
        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: url)
                DispatchQueue.main.async {
                    self.image = UIImage(data: data)
                }
            } catch {
                print(error)
            }
        }
    }
}
