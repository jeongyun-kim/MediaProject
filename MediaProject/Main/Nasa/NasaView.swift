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
    let progressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "다운로드 진행도를 알 수 있습니다 🚀"
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
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
    }
}
