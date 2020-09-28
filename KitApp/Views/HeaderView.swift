//
//  HeaderView.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class HeaderView: UIView, NibFileOwnerLoadable {
    
    @IBOutlet weak var displayImageVIew: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var viewModel: HeaderViewModel?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadNibContent()
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        loadNibContent()
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        displayImageVIew.layer.borderColor = Constants.ColorTheme.primaryYellow.cgColor
        displayImageVIew.layer.borderWidth = 2.0
    }
    
    func setup() {
        roundCorners([.bottomLeft, .bottomRight], radius: 50.0)
    }
    
    func setup(viewModel: HeaderViewModel) {
        self.viewModel = viewModel
        
        self.nameLabel.text = viewModel.nameLabel
        self.displayImageVIew.image = viewModel.displayImage
    }
    
    @IBAction func logoButtonPressed(_ sender: UIButton) {
        self.viewModel?.logoButtonPressed?()
    }
}
