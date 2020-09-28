//
//  ProfileImageTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraIcon: UIImageView!
    
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? ImageCellViewModel {
            profileImageView.image = viewModel.image?.value ?? UIImage()
            profileImageView.backgroundColor = viewModel.backGroundColor
            
            profileImageView.layer.borderColor = Constants.ColorTheme.appTheme.cgColor
            profileImageView.layer.borderWidth = 3.0
            
            viewModel.image?.addObserver(fireNow: false, { (image) in
                self.cameraIcon.isHidden = true
                self.profileImageView.image = image
            })
        }
    }
    
}
