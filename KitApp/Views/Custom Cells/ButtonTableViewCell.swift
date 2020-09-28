//
//  ButtonTableViewCell.swift
//  KitApp
//
//  Created by Kenneth Esguerra on 5/25/20.
//  Copyright © 2020 Kenneth Esguerra. All rights reserved.
//

import UIKit

enum ButtonType {
    case Continue
    case ContinueWithTop
    case Login
    case Register
    case Photo
    case PhotoContinue
}

class ButtonTableViewCell: UITableViewCell, ReusableView, NibLoadableView, CellConfigurable {
    var viewModel: ButtonTableViewCellViewModel?
    
    @IBOutlet weak var buttonWidthProportionConstraint: NSLayoutConstraint!
    

    func setup(viewModel: RowViewModel) {
        if let buttonTableViewCellViewModel = viewModel as? ButtonTableViewCellViewModel {
            self.viewModel = buttonTableViewCellViewModel
            button.title = self.viewModel?.text.value ?? ""
            button.isButtonEnabled = self.viewModel?.enabled.value ?? true
            button.colorTheme = self.viewModel?.colorTheme ?? Constants.ColorTheme.systemGray6
            
            self.viewModel?.enabled.addObserver(fireNow: false, { (enabled) in
                self.button.isButtonEnabled = enabled
            })
            
            switch self.viewModel?.buttonType {
            case .Photo:
                buttonWidthProportionConstraint.constant = -80.0
            default:
                buttonWidthProportionConstraint.constant = 0.0
            }
        }
    }
    
    @IBOutlet weak var button: RoundButton!
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        viewModel?.buttonPressed?()
    }
}
