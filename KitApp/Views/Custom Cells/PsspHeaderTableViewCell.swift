//
//  PsspHeaderTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/13/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PsspHeaderTableViewCell: UITableViewCell, CellConfigurable, NibLoadableView, ReusableView {
    
    @IBOutlet weak var sectionImageView: UIImageView!
    
    
    func setup(viewModel: RowViewModel) {
        if let psspHeaderViewModel = viewModel as? PsspHeaderTableViewCellViewModel {
            sectionImageView.image = UIImage(named: psspHeaderViewModel.imageName)
        }
    }
}


class PsspHeaderTableViewCellViewModel: RowViewModel {
    var rowHeight: Float = 80.0
    
    var imageName: String
    
    
    init(imageName: String) {
        self.imageName = imageName
    }
}
