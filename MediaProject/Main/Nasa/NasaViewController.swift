//
//  NasaViewController.swift
//  MediaProject
//
//  Created by 김정윤 on 7/1/24.
//

import UIKit

class NasaViewController: UIViewController {
    private let baseView = NasaView()
    
    override func loadView() {
        self.view = baseView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
