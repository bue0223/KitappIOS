//
//  InfoImageCollectionViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/28/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import SDWebImage

class InfoImageCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableView, CellConfigurable {
    
    @IBOutlet weak var displayImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    
    
    @IBOutlet weak var diskImageView: UIImageView!
    
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? InfoImageCollectionViewCellViewModel {
           // displayImageView.image = UIImage(data: viewModel.imageData ?? Data())
            //displayImageView.sd_setImage(with: URL(string: viewModel.imageUrlString ?? ""), completed: nil)
            
            if let data = viewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }else {
                displayImageView.image = nil
            }
            
            titleLabel.text = viewModel.title
            topConstraint.constant = viewModel.isLeaningUp == true ? -24.0 : -80.0
            diskImageView.image = UIImage(named: viewModel.diskImage)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
