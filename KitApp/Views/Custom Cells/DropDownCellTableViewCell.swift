//
//  DropDownCellTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 8/6/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class DropDownCellTableViewCell: UITableViewCell, NibLoadableView, ReusableView {
    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
