//
//  BottomNavigationView.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit


class BottomNavigationView: UIView, NibFileOwnerLoadable {
    
    
    var viewModel: BottomNavigationViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        //setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNibContent()
       // setup()
    }
    
    func setup(viewModel: BottomNavigationViewModel) {
        self.viewModel = viewModel
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        viewModel?.backButtonPressed?()
    }
    
    @IBAction func nextButtonPressed(_ sender: UIButton) {
        viewModel?.nextButtonPressed?()
    }
    
    
    
//    func setup() {
//        roundCorners([.bottomLeft, .bottomRight], radius: 50.0)
//    }
}
