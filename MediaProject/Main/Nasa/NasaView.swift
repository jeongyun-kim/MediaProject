//
//  NasaView.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import UIKit
import SnapKit

final class NasaView: BaseView {
    let nasaImageView = CustomImageView(cornerRadius: 8)
    let progressLabel = UILabel()
    let loadButton: UIButton = {
        let button = UIButton(configuration: .filled())
        button.backgroundColor = .tintColor
        button.setTitle("불러오기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 6
        return button
    }()
    
    override func setupHierarchy() {
        addSubview(nasaImageView)
        addSubview(progressLabel)
        addSubview(loadButton)
    }
    
    override func setupConstraints() {
        nasaImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(400)
        }
        
        progressLabel.snp.makeConstraints { make in
            make.top.equalTo(nasaImageView.snp.bottom).offset(8)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(16)
            make.height.equalTo(30)
        }
        
        loadButton.snp.makeConstraints { make in
            make.top.equalTo(progressLabel.snp.bottom).offset(8)
            make.centerX.equalTo(snp.centerX)
        }
    }
    
    override func setupUI() {
        super.setupUI()
        progressLabel.backgroundColor = .blue
        loadButton.addTarget(self, action: #selector(loadBtnTapped), for: .touchUpInside)
    }
    
    @objc func loadBtnTapped(_ sender: UIButton) {
        print(#function)
    }
}
