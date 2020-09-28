//
//  PriceProgramSectionHeaderTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/16/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PriceProgramSectionHeaderTableViewCell: UITableViewCell, CellConfigurable, NibLoadableView, ReusableView {
    @IBOutlet weak var displayImageView: UIImageView!
    
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as?  PriceProgramSectionHeaderViewModel {
            if let data = viewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }else {
                displayImageView.image = nil
            }
        }
    }
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}


class PriceProgramSectionHeaderViewModel: RowViewModel {
    var rowHeight: Float = 80.0
    
    var imageData: Data?
    
    init(imageData: Data? = nil) {
        self.imageData = imageData
    }

}
