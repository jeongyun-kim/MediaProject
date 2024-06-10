//
//  ReusableIdentifier.swift
//  MediaProject
//
//  Created by 김정윤 on 6/10/24.
//

import UIKit

protocol ReusableIdentifier {
    static var identifier: String { get }
}

extension UITableViewCell: ReusableIdentifier {
    static var identifier: String {
        return String(describing: self)
    }
}
