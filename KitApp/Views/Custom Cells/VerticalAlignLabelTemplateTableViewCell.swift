//
//  VerticalAlignLabelTemplateTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/9/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class VerticalAlignLabelTemplateTableViewCell: UITableViewCell, NibLoadableView, ReusableView, CellConfigurable {
    
    
    func setup(viewModel: RowViewModel) {
        firstLabel.text = "PMFTC"
        secondLabel.text = "100"
    }
    
    @IBOutlet weak var firstLabel: UILabel!
    @IBOutlet weak var secondLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
