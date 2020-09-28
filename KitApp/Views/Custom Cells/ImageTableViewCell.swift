//
//  ImageTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit
import ImageViewer_swift

class ImageTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {
    var viewModel: ImageCellViewModel?
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? ImageCellViewModel {
            displayImageView.image = UIImage(named: viewModel.name)
            displayImageView.backgroundColor = viewModel.backGroundColor
            //displayImageView.setupImageViewer(options: [.theme(.dark)], from: nil)
        }
    }
}
