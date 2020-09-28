//
//  ProductDisplayCollectionViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/8/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class ProductDisplayCollectionViewCell: UICollectionViewCell, NibLoadableView, ReusableView, CellConfigurable {
    
    
    @IBOutlet weak var displayImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var firstWholeNumberLabel: UILabel!
    
    @IBOutlet weak var firstDecimalNumberLabel: UILabel!
    
    @IBOutlet weak var secondWholeNumberlabel: UILabel!
    
    @IBOutlet weak var secondDecimalNumberLabel: UILabel!
    @IBOutlet weak var firstIconImageView: UIImageView!
    
    @IBOutlet weak var secondImageView: UIImageView!
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? PriceDisplayCellViewModel {
           // displayImageView.image = UIImage(data: viewModel.imageData ?? Data())
            //displayImageView.sd_setImage(with: URL(string: viewModel.imageUrlString ?? ""), completed: nil)
            
            if let data = viewModel.imageData {
                displayImageView.image = UIImage(data: data)
            }else {
                displayImageView.image = nil
            }
            titleLabel.text = viewModel.title
            firstWholeNumberLabel.text = viewModel.firstPrice
            secondWholeNumberlabel.text = viewModel.secondPrice
            
            firstDecimalNumberLabel.text = viewModel.firstDecimal
            secondDecimalNumberLabel.text = viewModel.secondDecimal
            
            firstIconImageView.image = UIImage(named: viewModel.firstImageName)
            secondImageView.image = UIImage(named: viewModel.secondImageName)
            
//            topConstraint.constant = viewModel.isLeaningUp == true ? 8.0 : 60.0
//            diskImageView.image = UIImage(named: viewModel.diskImage)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
