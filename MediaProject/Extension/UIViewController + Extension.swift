//
//  UIViewController + Extension.swift
//  MediaProject
//
//  Created by 김정윤 on 6/26/24.
//

import UIKit
import Toast
 
extension UIViewController {
    func showToast(message: String) {
        view.makeToast(message, position: .bottom)
    }
}
