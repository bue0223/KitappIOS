//
//  TitleWithSubTitleTemplateTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 7/15/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

class TitleWithSubTitleTemplateTableViewCell: UITableViewCell, ReusableView, NibLoadableView, CellConfigurable {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var messagesContainer: UIView!
    
    
    func setup(viewModel: RowViewModel) {
        if let viewModel = viewModel as? TitleWithSubTitleTemplateTableViewCellViewModel {
            titleLabel.text = viewModel.title
            subTitleLabel.text = viewModel.subTitle
            titleLabel.font = UIFont(name: "Roboto-Bold", size: viewModel.size)
            messagesContainer.layer.cornerRadius = 20.0
            titleLabel.textColor = viewModel.titleColor
            subTitleLabel.isHidden = viewModel.isSubTitleHidden
        }
    }
}
