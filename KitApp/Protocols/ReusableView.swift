//
//  ReusableView.swift
//  MySMAC
//
//  Created by Kenneth Esguerra on 2/20/19.
//  Copyright © 2019 Kenneth Esguerra. All rights reserved.
//

import Foundation
import UIKit

protocol ReusableView: class {
    static var defaultReuseIdentifier: String { get }
}

extension ReusableView where Self: UIView {
    static var nib: UINib {
        return UINib(nibName: defaultReuseIdentifier, bundle: Bundle(for: self))
    }
    
    static var defaultReuseIdentifier: String {
        return String(describing: self)
    }
}
