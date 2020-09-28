//
//  NibFileOwnerLoadable.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

public protocol NibFileOwnerLoadable: class {
    static var nib: UINib { get }
    static var nibName: String { get }
}

public extension NibFileOwnerLoadable where Self: UIView {
    
    static var nib: UINib {
        return UINib(nibName: String(describing: self), bundle: Bundle(for: self))
    }
    
    static var nibName: String {
        return String(describing: self)
    }
    
    func instantiateFromNib() -> UIView? {
        let view = Self.nib.instantiate(withOwner: self, options: nil).first as? UIView
        return view
    }
    
    func loadNibContent() {
        guard let view = instantiateFromNib() else {
            fatalError("Failed to instantiate nib \(Self.nib)")
        }
        view.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(view)
        let views = ["view": view]
        let verticalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[view]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[view]-0-|", options: .alignAllLastBaseline, metrics: nil, views: views)
        addConstraints(verticalConstraints + horizontalConstraints)
    }
}
