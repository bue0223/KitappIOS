//
//  NibLoadableView.swift
//  MySMAC
//
//  Created by Kenneth Esguerra on 2/20/19.
//  Copyright © 2019 Kenneth Esguerra. All rights reserved.
//

import Foundation
import UIKit

protocol NibLoadableView: class {
    static var nibName: String { get }
}

extension NibLoadableView where Self: UIView {
    static var nibName: String {
        return String(describing: self)
    }
}
