//
//  PsspItemTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/13/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class PsspItemTableViewCell: UITableViewCell, CellConfigurable, NibLoadableView, ReusableView {

    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var priceWholeNumberLabel: UILabel!
    @IBOutlet weak var priceDecimalLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }
    
    func setup(viewModel: RowViewModel) {
        if let psspCellViewModel = viewModel as? PsspItemCellViewModel {
            
            priceWholeNumberLabel.text = psspCellViewModel.firstPrice
            priceDecimalLabel.text = psspCellViewModel.firstPriceDecimal

            if let data = psspCellViewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
