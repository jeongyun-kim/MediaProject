//
//  NasaViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import UIKit

final class NasaViewController: UIViewController {
    private let baseView = NasaView()
    private var session: URLSession! // IUO
    private let totalKey = "Content-Length"
    private var totalData: Double = 0
    private var buffer: Data? = Data() {
        didSet {
            if let buffer = buffer {
                let progress = Double(buffer.count) / totalData * 100
                let result = round(progress*100)/100
                baseView.progressLabel.text = "\(result)%"
            }
        }
    }
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        baseView.loadButton.addTarget(self, action: #selector(loadBtnTapped), for: .touchUpInside)
        setupNavigation()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // 다운로드 완료될 때까지는 냅뒀다가 완료되면 리소스 정리
        session.finishTasksAndInvalidate()
    }
    
    @objc func loadBtnTapped(_ sender: UIButton) {
        fetchNasaImage()
    }
    
    private func fetchNasaImage() {
        // 세션 Configuration
        // - 진행도를 받아오기 위해서는 default -> dataTask -> delegate
        session = URLSession(configuration: .default, delegate: self, delegateQueue: .main)
        guard let url = NasaRequestCase.image.endPoint else { return }
        let request = URLRequest(url: url)
        session.dataTask(with: request).resume()
    }
    
    private func setupNavigation() {
        navigationItem.title = "⭐️ 오늘의 Nasa 이미지 ⭐️"
    }
}

extension NasaViewController: URLSessionDataDelegate {
    // 1. response
    // - repsponse가 있으면 총 데이터 사이즈 받아오기
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse) async -> URLSession.ResponseDisposition {
        // 받아온 response를 HTTPURLResponse로 변환했을 때 nil이 아니면
        // + statusCode가 200번대라면 성공으로 간주
        if let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) {
            guard let responsedTotalData = response.value(forHTTPHeaderField: totalKey) else { return .cancel }
            guard let result = Double(responsedTotalData) else { return .cancel }
            totalData = result
            return .allow
        } else { // - response가 없으면 네트워크 동작 취소
            return .cancel
        }
    }
    
    // 2. data
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        buffer?.append(data)
    }
    
    // 3. complete(error)
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
        if let error = error {
            showToast(message: NasaRequestCase.image.errorMessage)
        } else {
            guard let buffer = buffer else { return }
            baseView.nasaImageView.image = UIImage(data: buffer)
        }
    }
}
